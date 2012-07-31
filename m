From: akpm@linux-foundation.org
Subject: [merged] vsprintf-add-support-of-%ph.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:50:00 -0700
Message-ID: <20120731185001.171C6200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:51872 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756254Ab2GaSuD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2012 14:50:03 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id r15so292127lag.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:50:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vsprintf: add support of '%*ph[CDN]'
has been removed from the -mm tree.  Its filename was
     vsprintf-add-support-of-%ph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: vsprintf: add support of '%*ph[CDN]'

There are many places in the kernel where the drivers print small buffers
as a hex string.  This patch adds a support of the variable width buffer
to print it as a hex string with a delimiter.  The idea came from Pavel
Roskin here: http://www.digipedia.pl/usenet/thread/18835/17449/

Sample output of
	pr_info("buf[%d:%d] %*phC\n", from, len, len, &buf[from]);
could be look like this:
	[ 0.726130] buf[51:8] e8:16:b6:ef:e3:74:45:6e
	[ 0.750736] buf[59:15] 31:81:b8:3f:35:49:06:ae:df:32:06:05:4a:af:55
	[ 0.757602] buf[17:5] ac:16:d5:2c:ef

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/printk-formats.txt |   10 +++++
 lib/vsprintf.c                   |   55 +++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff -puN Documentation/printk-formats.txt~vsprintf-add-support-of-%ph Documentation/printk-formats.txt
--- a/Documentation/printk-formats.txt~vsprintf-add-support-of-%ph
+++ a/Documentation/printk-formats.txt
@@ -53,6 +53,16 @@ Struct Resources:
 	For printing struct resources. The 'R' and 'r' specifiers result in a
 	printed resource with ('R') or without ('r') a decoded flags member.
 
+Raw buffer as a hex string:
+	%*ph	00 01 02  ...  3f
+	%*phC	00:01:02: ... :3f
+	%*phD	00-01-02- ... -3f
+	%*phN	000102 ... 3f
+
+	For printing a small buffers (up to 64 bytes long) as a hex string with
+	certain separator. For the larger buffers consider to use
+	print_hex_dump().
+
 MAC/FDDI addresses:
 
 	%pM	00:01:02:03:04:05
diff -puN lib/vsprintf.c~vsprintf-add-support-of-%ph lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-add-support-of-%ph
+++ a/lib/vsprintf.c
@@ -655,6 +655,50 @@ char *resource_string(char *buf, char *e
 }
 
 static noinline_for_stack
+char *hex_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
+		 const char *fmt)
+{
+	int i, len = 1;		/* if we pass '%ph[CDN]', field witdh remains
+				   negative value, fallback to the default */
+	char separator;
+
+	if (spec.field_width == 0)
+		/* nothing to print */
+		return buf;
+
+	if (ZERO_OR_NULL_PTR(addr))
+		/* NULL pointer */
+		return string(buf, end, NULL, spec);
+
+	switch (fmt[1]) {
+	case 'C':
+		separator = ':';
+		break;
+	case 'D':
+		separator = '-';
+		break;
+	case 'N':
+		separator = 0;
+		break;
+	default:
+		separator = ' ';
+		break;
+	}
+
+	if (spec.field_width > 0)
+		len = min_t(int, spec.field_width, 64);
+
+	for (i = 0; i < len && buf < end - 1; i++) {
+		buf = hex_byte_pack(buf, addr[i]);
+
+		if (buf < end && separator && i != len - 1)
+			*buf++ = separator;
+	}
+
+	return buf;
+}
+
+static noinline_for_stack
 char *mac_address_string(char *buf, char *end, u8 *addr,
 			 struct printf_spec spec, const char *fmt)
 {
@@ -974,6 +1018,13 @@ int kptr_restrict __read_mostly;
  *       correctness of the format string and va_list arguments.
  * - 'K' For a kernel pointer that should be hidden from unprivileged users
  * - 'NF' For a netdev_features_t
+ * - 'h[CDN]' For a variable-length buffer, it prints it as a hex string with
+ *            a certain separator (' ' by default):
+ *              C colon
+ *              D dash
+ *              N no separator
+ *            The maximum supported length is 64 bytes of the input. Consider
+ *            to use print_hex_dump() for the larger input.
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -1007,6 +1058,8 @@ char *pointer(const char *fmt, char *buf
 	case 'R':
 	case 'r':
 		return resource_string(buf, end, ptr, spec, fmt);
+	case 'h':
+		return hex_string(buf, end, ptr, spec, fmt);
 	case 'M':			/* Colon separated: 00:01:02:03:04:05 */
 	case 'm':			/* Contiguous: 000102030405 */
 					/* [mM]F (FDDI) */
@@ -1296,6 +1349,8 @@ qualifier:
  * %pI6c print an IPv6 address as specified by RFC 5952
  * %pU[bBlL] print a UUID/GUID in big or little endian using lower or upper
  *   case.
+ * %*ph[CDN] a variable-length hex string with a separator (supports up to 64
+ *           bytes of the input)
  * %n is ignored
  *
  * ** Please update Documentation/printk-formats.txt when making changes **
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch

