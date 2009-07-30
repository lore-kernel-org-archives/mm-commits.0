From: akpm@linux-foundation.org
Subject: [merged] kexec-fix-omitting-offset-in-extended-crashkernel-syntax.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:34:59 -0700
Message-ID: <200907302034.n6UKYxpk007440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751616AbZG3UfI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:35:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: seto.hidetoshi@jp.fujitsu.com, jin.dongming@np.css.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     kexec: fix omitting offset in extended crashkernel syntax
has been removed from the -mm tree.  Its filename was
     kexec-fix-omitting-offset-in-extended-crashkernel-syntax.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec: fix omitting offset in extended crashkernel syntax
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Setting
 "crashkernel=512M-2G:64M,2G-:128M"
does not work but it turns to work if it has a trailing-whitespace,
like
 "crashkernel=512M-2G:64M,2G-:128M ".

It was because of a bug in the parser, running over the cmdline.

This patch adds a check of the termination.

Reported-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Tested-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kexec.c~kexec-fix-omitting-offset-in-extended-crashkernel-syntax kernel/kexec.c
--- a/kernel/kexec.c~kexec-fix-omitting-offset-in-extended-crashkernel-syntax
+++ a/kernel/kexec.c
@@ -1228,7 +1228,7 @@ static int __init parse_crashkernel_mem(
 	} while (*cur++ == ',');
 
 	if (*crash_size > 0) {
-		while (*cur != ' ' && *cur != '@')
+		while (*cur && *cur != ' ' && *cur != '@')
 			cur++;
 		if (*cur == '@') {
 			cur++;
_

Patches currently in -mm which might be from seto.hidetoshi@jp.fujitsu.com are

origin.patch

