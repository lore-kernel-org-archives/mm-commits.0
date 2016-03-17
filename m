From: akpm@linux-foundation.org
Subject: [folded-merged]
 param-convert-some-on-off-users-to-strtobool-fix.patch removed from -mm
 tree
Date: Thu, 17 Mar 2016 14:03:21 -0700
Message-ID: <56eb1b99.9Ba8zZJXxSlM8yTd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030620AbcCQVDW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 17:03:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: param-convert-some-on-off-users-to-strtobool fix
has been removed from the -mm tree.  Its filename was
     param-convert-some-on-off-users-to-strtobool-fix.patch

This patch was dropped because it was folded into param-convert-some-on-off-users-to-strtobool.patch

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: param-convert-some-on-off-users-to-strtobool fix

This converts a missed __setup return (and silences the build warning it
was causing).

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/rtasd.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/powerpc/kernel/rtasd.c~param-convert-some-on-off-users-to-strtobool-fix arch/powerpc/kernel/rtasd.c
--- a/arch/powerpc/kernel/rtasd.c~param-convert-some-on-off-users-to-strtobool-fix
+++ a/arch/powerpc/kernel/rtasd.c
@@ -592,8 +592,6 @@ __setup("surveillance=", surveillance_se
 
 static int __init rtasmsgs_setup(char *str)
 {
-	kstrtobool(str, &full_rtas_msgs);
