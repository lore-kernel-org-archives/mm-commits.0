From: akpm@linux-foundation.org
Subject: + fs-coredump-prevent-core-path-components.patch added to -mm
 tree
Date: Tue, 05 Jan 2016 13:52:34 -0800
Message-ID: <568c3b22.+hYvovM+WhLLOu2e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38561 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbcAEVwf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jan 2016 16:52:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jann@thejh.net, keescook@chromium.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/coredump: prevent "" / "." / ".." core path components
has been added to the -mm tree.  Its filename is
     fs-coredump-prevent-core-path-components.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-coredump-prevent-core-path-components.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-coredump-prevent-core-path-components.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jann Horn <jann@thejh.net>
Subject: fs/coredump: prevent "" / "." / ".." core path components

Let %h and %e print empty values as "!", "." as "!" and
".." as "!.".

This prevents hostnames and comm values that are empty or consist of one
or two dots from changing the directory level at which the corefile will
be stored.

It seems very unlikely that this caused security issues anywhere, so I'm
not requesting a stable backport.

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
@@ -117,6 +117,26 @@ int cn_esc_printf(struct core_name *cn,
 	ret = cn_vprintf(cn, fmt, arg);
 	va_end(arg);
 
+	if (ret == 0) {
+		/*
+		 * Ensure that this coredump name component can't cause the
+		 * resulting corefile path to contain a ".." or "." component.
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

security-let-security-modules-use-ptrace_mode_-with-bitmasks.patch
ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks.patch
fs-coredump-prevent-core-path-components.patch

