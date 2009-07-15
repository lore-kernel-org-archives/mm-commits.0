From: akpm@linux-foundation.org
Subject: + kexec-fix-omitting-offset-in-extended-crashkernel-syntax.patch added to -mm tree
Date: Wed, 15 Jul 2009 15:26:33 -0700
Message-ID: <200907152226.n6FMQXF6029866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755423AbZGOW1K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 18:27:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: seto.hidetoshi@jp.fujitsu.com, jin.dongming@np.css.fujitsu.com


The patch titled
     kexec: fix omitting offset in extended crashkernel syntax
has been added to the -mm tree.  Its filename is
     kexec-fix-omitting-offset-in-extended-crashkernel-syntax.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

kexec-fix-omitting-offset-in-extended-crashkernel-syntax.patch

