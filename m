Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B89F37D13D
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 04:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782708109; cv=none; b=YujnBdlaMtbzpyKhpopUzx6SpyS3rUjR+3l4trbo3lpnsCM+y6YUPXvLnQytA3ur9CnG76TKEjYz6RQW5vnmNyauW2F/8MmUKnc0ftia6TKqwh3CypDr1uJI9k3VOND6MJcxcWBGRBPTiel6NBIoJ6UkB0D6q2XBfDdcmY5TaiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782708109; c=relaxed/simple;
	bh=gXohQgk9n4I4bBRgQGFTZxftA/vpP+WmciOVL0DcmJg=;
	h=Date:To:From:Subject:Message-Id; b=iGTN0rfZxURGn99HgRqT3reEB0undB+oW2mf56rXrqmu4rm9IDVf5kuxszchmMn38tJpbQy6AaVswNCwQPPqJVH6TCAgnWAuIxywTP9Rtsa7okXX7+q9EgW2x2nJ+X2edqu8fLUUyf4aVK2OsIbX13S5+X8xyQZ1ywASk8+uccE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pekB15Fn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pekB15Fn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C22F1F000E9;
	Mon, 29 Jun 2026 04:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782708108;
	bh=71aY+7kZga9n9TYdZVTHOZjftqegOYTtCNJp7US2x5Q=;
	h=Date:To:From:Subject;
	b=pekB15FnvhQPhWEVkjoXDwK+FG/PvlWEO4UOk6pmXybs2l3A0cupY0cSZXAyuMnjc
	 XrdmaUWhvvXCqr2K7DNyCanVB7HcQuHYXjGid2WI2ALylTw9tWgi6LrCmal+pSJ3yM
	 JppkrBLRLWrY5aJYupqie/tLSlbfsfX3YD4eOYBw=
Date: Sun, 28 Jun 2026 21:41:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhen.ni@easystack.cn,ye.liu@linux.dev,vishal.moola@gmail.com,chenyichong@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-page_owner_sort-bound-pattern-output-copies.patch added to mm-new branch
Message-Id: <20260629044148.0C22F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm/page_owner_sort: bound pattern output copies
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-page_owner_sort-bound-pattern-output-copies.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-page_owner_sort-bound-pattern-output-copies.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Yichong Chen <chenyichong@uniontech.com>
Subject: tools/mm/page_owner_sort: bound pattern output copies
Date: Mon, 29 Jun 2026 09:43:16 +0800

search_pattern() copies a regex capture into caller-provided buffers
without knowing their sizes.  Several callers pass fixed-size buffers,
including FIELD_BUFF and TASK_COMM_LEN.

Pass the destination size to search_pattern(), reject captures that do not
fit before copying them, and terminate the output string inside
search_pattern().

Link: https://lore.kernel.org/20260629014316.130307-4-chenyichong@uniontech.com
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Cc: Vishal Moola <vishal.moola@gmail.com>
Cc: Ye Liu <ye.liu@linux.dev>
Cc: Zhen Ni <zhen.ni@easystack.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page_owner_sort.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

--- a/tools/mm/page_owner_sort.c~tools-mm-page_owner_sort-bound-pattern-output-copies
+++ a/tools/mm/page_owner_sort.c
@@ -237,7 +237,8 @@ static int remove_pattern(regex_t *patte
 	return len - (pmatch[1].rm_eo - pmatch[1].rm_so);
 }
 
-static int search_pattern(regex_t *pattern, char *pattern_str, char *buf)
+static int search_pattern(regex_t *pattern, char *pattern_str,
+			  size_t pattern_str_size, char *buf)
 {
 	int err, val_len;
 	regmatch_t pmatch[2];
@@ -249,8 +250,14 @@ static int search_pattern(regex_t *patte
 		return -1;
 	}
 	val_len = pmatch[1].rm_eo - pmatch[1].rm_so;
+	if ((size_t)val_len >= pattern_str_size) {
+		if (debug_on)
+			fprintf(stderr, "pattern too long in %s\n", buf);
+		return -1;
+	}
 
 	memcpy(pattern_str, buf + pmatch[1].rm_so, val_len);
+	pattern_str[val_len] = '\0';
 
 	return 0;
 }
@@ -307,7 +314,8 @@ static int get_page_num(char *buf)
 	char order_str[FIELD_BUFF] = {0};
 	char *endptr;
 
-	search_pattern(&order_pattern, order_str, buf);
+	if (search_pattern(&order_pattern, order_str, sizeof(order_str), buf) < 0)
+		return 0;
 	errno = 0;
 	order_val = strtol(order_str, &endptr, 10);
 	if (order_val > 64 || errno != 0 || endptr == order_str || *endptr != '\0') {
@@ -325,7 +333,8 @@ static pid_t get_pid(char *buf)
 	char pid_str[FIELD_BUFF] = {0};
 	char *endptr;
 
-	search_pattern(&pid_pattern, pid_str, buf);
+	if (search_pattern(&pid_pattern, pid_str, sizeof(pid_str), buf) < 0)
+		return -1;
 	errno = 0;
 	pid = strtol(pid_str, &endptr, 10);
 	if (errno != 0 || endptr == pid_str || *endptr != '\0') {
@@ -344,7 +353,8 @@ static pid_t get_tgid(char *buf)
 	char tgid_str[FIELD_BUFF] = {0};
 	char *endptr;
 
-	search_pattern(&tgid_pattern, tgid_str, buf);
+	if (search_pattern(&tgid_pattern, tgid_str, sizeof(tgid_str), buf) < 0)
+		return -1;
 	errno = 0;
 	tgid = strtol(tgid_str, &endptr, 10);
 	if (errno != 0 || endptr == tgid_str || *endptr != '\0') {
@@ -363,7 +373,9 @@ static __u64 get_ts_nsec(char *buf)
 	char ts_nsec_str[FIELD_BUFF] = {0};
 	char *endptr;
 
-	search_pattern(&ts_nsec_pattern, ts_nsec_str, buf);
+	if (search_pattern(&ts_nsec_pattern, ts_nsec_str,
+			   sizeof(ts_nsec_str), buf) < 0)
+		return -1;
 	errno = 0;
 	ts_nsec = strtoull(ts_nsec_str, &endptr, 10);
 	if (errno != 0 || endptr == ts_nsec_str || *endptr != '\0') {
@@ -384,7 +396,10 @@ static char *get_comm(char *buf)
 
 	memset(comm_str, 0, TASK_COMM_LEN);
 
-	search_pattern(&comm_pattern, comm_str, buf);
+	if (search_pattern(&comm_pattern, comm_str, TASK_COMM_LEN, buf) < 0) {
+		free(comm_str);
+		return NULL;
+	}
 	errno = 0;
 	if (errno != 0) {
 		if (debug_on)
_

Patches currently in -mm which might be from chenyichong@uniontech.com are

tools-mm-page_owner_sort-return-explicit-filter-results.patch
tools-mm-page_owner_sort-free-per-record-allocations.patch
tools-mm-page_owner_sort-bound-pattern-output-copies.patch

