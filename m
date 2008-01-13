From: akpm@linux-foundation.org
Subject: - kernel-compliment-va_copy-with-va_end.patch removed from -mm tree
Date: Sun, 13 Jan 2008 03:34:12 -0800
Message-ID: <200801131133.m0DBXqaM009883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51867 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348AbYAMLjA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 06:39:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     audit: complement va_copy with va_end()
has been removed from the -mm tree.  Its filename was
     kernel-compliment-va_copy-with-va_end.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: audit: complement va_copy with va_end()
From: Richard Knutsson <ricknu-0@student.ltu.se>

Complement va_copy() with va_end().

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/audit.c~kernel-compliment-va_copy-with-va_end kernel/audit.c
--- a/kernel/audit.c~kernel-compliment-va_copy-with-va_end
+++ a/kernel/audit.c
@@ -1245,6 +1245,7 @@ static void audit_log_vformat(struct aud
 			goto out;
 		len = vsnprintf(skb_tail_pointer(skb), avail, fmt, args2);
 	}
+	va_end(args2);
 	if (len > 0)
 		skb_put(skb, len);
 out:
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

git-audit-master.patch
git-dvb.patch
pcmcia-3c574_cs-fix-dubious-bitfield-warning.patch
pcmcia-3c574_cs-fix-shadow-variable-warning.patch
pcmcia-axnet_cs-make-functions-static.patch
pcmcia-axnet_cs-make-use-of-max-instead-of-handcrafted-one.patch
pcmcia-fmvj18x_cs-fix-shadow-variable-warning.patch
pcmcia-pcnet_cs-fix-shadow-variable-warning.patch
git-selinux.patch
dio-array_size-cleanup-update.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
reiserfs-complement-va_start-with-va_end.patch
kernel-paramsc-remove-sparse-warning-different-signedness.patch
