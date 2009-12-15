From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintfc-add-%pu-to-print-uuid-guids.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:57:54 -0800
Message-ID: <200912152157.nBFLvshu015759@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933840AbZLOV77 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:59:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, adrian.hunter@nokia.com, aelder@sgi.com, dedekind@infradead.org, hch@lst.de, jgarzik@redhat.com, mchehab@infradead.org, mpm@selenic.com, neilb@suse.de, swhiteho@redha


The patch titled
     lib/vsprintf.c: add %pU to print UUID/GUIDs
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-add-%pu-to-print-uuid-guids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/vsprintf.c: add %pU to print UUID/GUIDs
From: Joe Perches <joe@perches.com>

UUID/GUIDs are somewhat common in kernel source.

Standardize the printed style of UUID/GUIDs by using
another extension to %p.

%pUb:   01020304-0506-0708-090a-0b0c0d0e0f10
%pUB:   01020304-0506-0708-090A-0B0C0D0E0F10 (upper case)
%pUl:   04030201-0605-0807-090a-0b0c0d0e0f10
%pUL:   04030201-0605-0807-090A-0B0C0D0E0F10 (upper case)

%pU defaults to %pUb

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-add-%pu-to-print-uuid-guids lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-add-%pu-to-print-uuid-guids
+++ a/lib/vsprintf.c
@@ -834,6 +834,52 @@ static char *ip4_addr_string(char *buf, 
 	return string(buf, end, ip4_addr, spec);
 }
 
+static char *uuid_string(char *buf, char *end, const u8 *addr,
+			 struct printf_spec spec, const char *fmt)
+{
+	char uuid[sizeof("xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")];
+	char *p = uuid;
+	int i;
+	static const u8 be[16] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
+	static const u8 le[16] = {3,2,1,0,5,4,7,6,8,9,10,11,12,13,14,15};
+	const u8 *index = be;
+	bool uc = false;
+
+	switch (*(++fmt)) {
+	case 'L':
+		uc = true;		/* fall-through */
+	case 'l':
+		index = le;
+		break;
+	case 'B':
+		uc = true;
+		break;
+	}
+
+	for (i = 0; i < 16; i++) {
+		p = pack_hex_byte(p, addr[index[i]]);
+		switch (i) {
+		case 3:
+		case 5:
+		case 7:
+		case 9:
+			*p++ = '-';
+			break;
+		}
+	}
+
+	*p = 0;
+
+	if (uc) {
+		p = uuid;
+		do {
+			*p = toupper(*p);
+		} while (*(++p));
+	}
+
+	return string(buf, end, uuid, spec);
+}
+
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
@@ -858,6 +904,18 @@ static char *ip4_addr_string(char *buf, 
  *       IPv4 uses dot-separated decimal with leading 0's (010.123.045.006)
  * - 'I6c' for IPv6 addresses printed as specified by
  *       http://www.ietf.org/id/draft-kawamura-ipv6-text-representation-03.txt
+ * - 'U' For a 16 byte UUID/GUID, it prints the UUID/GUID in the form
+ *       "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
+ *       Options for %pU are:
+ *         b big endian lower case hex (default)
+ *         B big endian UPPER case hex
+ *         l little endian lower case hex
+ *         L little endian UPPER case hex
+ *           big endian output byte order is:
+ *             [0][1][2][3]-[4][5]-[6][7]-[8][9]-[10][11][12][13][14][15]
+ *           little endian output byte order is:
+ *             [3][2][1][0]-[5][4]-[7][6]-[8][9]-[10][11][12][13][14][15]
+ *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
  * pointer to the real address.
@@ -873,8 +931,8 @@ static char *pointer(const char *fmt, ch
 	case 'f':
 		ptr = dereference_function_descriptor(ptr);
 		/* Fallthrough */
-	case 's':
 	case 'S':
+	case 's':
 		return symbol_string(buf, end, ptr, spec, *fmt);
 	case 'R':
 	case 'r':
@@ -898,6 +956,8 @@ static char *pointer(const char *fmt, ch
 			return ip4_addr_string(buf, end, ptr, spec, fmt);
 		}
 		break;
+	case 'U':
+		return uuid_string(buf, end, ptr, spec, fmt);
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
isicomc-use-pr_fmt-and-pr_level.patch
parport_pcc-use-correct-length-in-strncmp.patch

