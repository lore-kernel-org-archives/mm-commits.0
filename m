From: akpm@linux-foundation.org
Subject: [merged] init-mainc-obsolete_checksetup-can-be-boolean.patch
 removed from -mm tree
Date: Thu, 21 Jan 2016 14:59:22 -0800
Message-ID: <56a162ca.IEmUsXAA12uH+hOW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33889 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbcAUW7X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:59:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: init/main.c: obsolete_checksetup can be boolean
has been removed from the -mm tree.  Its filename was
     init-mainc-obsolete_checksetup-can-be-boolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: init/main.c: obsolete_checksetup can be boolean

Make obsolete_checksetup() return bool due to this particular function
only using either one or zero as its return value.

No functional change.

Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN init/main.c~init-mainc-obsolete_checksetup-can-be-boolean init/main.c
--- a/init/main.c~init-mainc-obsolete_checksetup-can-be-boolean
+++ a/init/main.c
@@ -164,10 +164,10 @@ static const char *panic_later, *panic_p
 
 extern const struct obs_kernel_param __setup_start[], __setup_end[];
 
-static int __init obsolete_checksetup(char *line)
+static bool __init obsolete_checksetup(char *line)
 {
 	const struct obs_kernel_param *p;
-	int had_early_param = 0;
+	bool had_early_param = false;
 
 	p = __setup_start;
 	do {
@@ -179,13 +179,13 @@ static int __init obsolete_checksetup(ch
 				 * Keep iterating, as we can have early
 				 * params and __setups of same names 8( */
 				if (line[n] == '\0' || line[n] == '=')
-					had_early_param = 1;
+					had_early_param = true;
 			} else if (!p->setup_func) {
 				pr_warn("Parameter %s is obsolete, ignored\n",
 					p->str);
-				return 1;
+				return true;
 			} else if (p->setup_func(line + n))
-				return 1;
+				return true;
 		}
 		p++;
 	} while (p < __setup_end);
_

Patches currently in -mm which might be from baiyaowei@cmss.chinamobile.com are


