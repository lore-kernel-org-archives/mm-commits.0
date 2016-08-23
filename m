From: akpm@linux-foundation.org
Subject: + fixdep-faster-config_-search.patch added to -mm tree
Date: Tue, 23 Aug 2016 13:38:10 -0700
Message-ID: <57bcb432.8vZo+Eag/CLE3bNN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51360 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754535AbcHWUiL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 23 Aug 2016 16:38:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fixdep: faster CONFIG_ search
has been added to the -mm tree.  Its filename is
     fixdep-faster-config_-search.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fixdep-faster-config_-search.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fixdep-faster-config_-search.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: fixdep: faster CONFIG_ search

Do you think kernel build is 100% dominated by gcc?  You are wrong!  One
small utility called "fixdep" consistently manages to sneak into profile's
first page (unless you have small monitor of course).

The choke point is this clever code:

	for (; m < end; m++) {
		if (*m == INT_CONF) { p = (char *) m  ; goto conf; }
		if (*m == INT_ONFI) { p = (char *) m-1; goto conf; }
		if (*m == INT_NFIG) { p = (char *) m-2; goto conf; }
		if (*m == INT_FIG_) { p = (char *) m-3; goto conf; }

4 branches per 4 characters is not fast.

Use strstr(3), so that SSE2 etc can be used.

With this patch, fixdep is so deep at the bottom, it is hard to find it.

Link: http://lkml.kernel.org/r/20160823184724.GA11707@p183.telecom.by
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/basic/fixdep.c |   67 ++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 39 deletions(-)

diff -puN scripts/basic/fixdep.c~fixdep-faster-config_-search scripts/basic/fixdep.c
--- a/scripts/basic/fixdep.c~fixdep-faster-config_-search
+++ a/scripts/basic/fixdep.c
@@ -82,8 +82,7 @@
  * to date before even starting the recursive build, so it's too late
  * at this point anyway.
  *
- * The algorithm to grep for "CONFIG_..." is bit unusual, but should
- * be fast ;-) We don't even try to really parse the header files, but
+ * We don't even try to really parse the header files, but
  * merely grep, i.e. if CONFIG_FOO is mentioned in a comment, it will
  * be picked up as well. It's not a problem with respect to
  * correctness, since that can only give too many dependencies, thus
@@ -241,37 +240,22 @@ static void use_config(const char *m, in
 	print_config(m, slen);
 }
 
-static void parse_config_file(const char *map, size_t len)
+static void parse_config_file(const char *p)
 {
-	const int *end = (const int *) (map + len);
-	/* start at +1, so that p can never be < map */
-	const int *m   = (const int *) map + 1;
-	const char *p, *q;
-
-	for (; m < end; m++) {
-		if (*m == INT_CONF) { p = (char *) m  ; goto conf; }
-		if (*m == INT_ONFI) { p = (char *) m-1; goto conf; }
-		if (*m == INT_NFIG) { p = (char *) m-2; goto conf; }
-		if (*m == INT_FIG_) { p = (char *) m-3; goto conf; }
-		continue;
-	conf:
-		if (p > map + len - 7)
-			continue;
-		if (memcmp(p, "CONFIG_", 7))
-			continue;
-		p += 7;
-		for (q = p; q < map + len; q++) {
-			if (!(isalnum(*q) || *q == '_'))
-				goto found;
-		}
-		continue;
+	const char *q, *r;
 
-	found:
-		if (!memcmp(q - 7, "_MODULE", 7))
-			q -= 7;
-		if (q - p < 0)
-			continue;
-		use_config(p, q - p);
+	while ((p = strstr(p, "CONFIG_"))) {
+		p += 7;
+		q = p;
+		while (*q && (isalnum(*q) || *q == '_'))
+			q++;
+		if (memcmp(q - 7, "_MODULE", 7) == 0)
+			r = q - 7;
+		else
+			r = q;
+		if (r > p)
+			use_config(p, r - p);
+		p = q;
 	}
 }
 
@@ -291,7 +275,7 @@ static void do_config_file(const char *f
 {
 	struct stat st;
 	int fd;
-	void *map;
+	char *map;
 
 	fd = open(filename, O_RDONLY);
 	if (fd < 0) {
@@ -308,18 +292,23 @@ static void do_config_file(const char *f
 		close(fd);
 		return;
 	}
-	map = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
-	if ((long) map == -1) {
-		perror("fixdep: mmap");
+	map = malloc(st.st_size + 1);
+	if (!map) {
+		perror("fixdep: malloc");
 		close(fd);
 		return;
 	}
+	if (read(fd, map, st.st_size) != st.st_size) {
+		perror("fixdep: read");
+		close(fd);
+		return;
+	}
+	map[st.st_size] = '\0';
+	close(fd);
 
-	parse_config_file(map, st.st_size);
