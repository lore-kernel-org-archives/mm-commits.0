From: akpm@linux-foundation.org
Subject: [merged] fs-coredump-prevent-core-path-components.patch removed
 from -mm tree
Date: Thu, 21 Jan 2016 14:59:57 -0800
Message-ID: <56a162ed.EnS/6J94/bRljikc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbcAUW76 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:59:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jann@thejh.net, keescook@chromium.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/coredump: prevent "" / "." / ".." core path components
has been removed from the -mm tree.  Its filename was
     fs-coredump-prevent-core-path-components.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jann Horn <jann@thejh.net>
Subject: fs/coredump: prevent "" / "." / ".." core path components

Let %h and %e print empty values as "!", "." as "!" and
".." as "!.".

This prevents hostnames and comm values that are empty or consist of one
or two dots from changing the directory level at which the corefile will
be stored.

Consider the case where someone decides to sort coredumps by hostname
with a core pattern like "/cores/%h/core.%e.%p.%t" or so.  In this
case, hostnames "" and "." would cause the coredump to land directly in
/cores, which is not what the intent behind the core pattern is, and
".." would cause the coredump to land in /.

Yeah, there probably aren't many people who do that, but I still don't
want this edgecase to be kind of broken.

It seems very unlikely that this caused security issues anywhere, so I'm
not requesting a stable backport.

[akpm@linux-foundation.org: tweak code comment]
Signed-off-by: Jann Horn <jann@thejh.net>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN fs/coredump.c~fs-coredump-prevent-core-path-components fs/coredump.c
--- a/fs/coredump.c~fs-coredump-prevent-core-path-components
+++ a/fs/coredump.c
@@ -118,6 +118,26 @@ int cn_esc_printf(struct core_name *cn,
 	ret = cn_vprintf(cn, fmt, arg);
 	va_end(arg);
 
+	if (ret == 0) {
+		/*
+		 * Ensure that this coredump name component can't cause the
+		 * resulting corefile path to consist of a ".." or ".".
+		 */
+		if ((cn->used - cur == 1 && cn->corename[cur] == '.') ||
+				(cn->used - cur == 2 && cn->corename[cur] == '.'
+				&& cn->corename[cur+1] == '.'))
+			cn->corename[cur] = '!';
+
+		/*
+		 * Empty names are fishy and could be used to create a "//" in a
+		 * corefile name, causing the coredump to happen one directory
+		 * level too high. Enforce that all components of the core
+		 * pattern are at least one character long.
+		 */
+		if (cn->used == cur)
+			ret = cn_printf(cn, "!");
+	}
+
 	for (; cur < cn->used; ++cur) {
 		if (cn->corename[cur] == '/')
 			cn->corename[cur] = '!';
_

Patches currently in -mm which might be from jann@thejh.net are


