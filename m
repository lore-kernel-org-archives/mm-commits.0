From: akpm@linux-foundation.org
Subject: + ihex-restore-missing-default-in-switch-statement.patch added to -mm tree
Date: Wed, 04 Mar 2015 14:18:20 -0800
Message-ID: <54f784ac.fpi9UP22vRwrEb4S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbbCDWSV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 17:18:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.iooss_linux@m4x.org, broonie@opensource.wolfsonmicro.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: firmware/ihex2fw.c: restore missing default in switch statement
has been added to the -mm tree.  Its filename is
     ihex-restore-missing-default-in-switch-statement.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ihex-restore-missing-default-in-switch-statement.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ihex-restore-missing-default-in-switch-statement.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: firmware/ihex2fw.c: restore missing default in switch statement

Commit 2473238eac95 ("ihex: add support for CS:IP/EIP records") removes
the "default:" statement in the switch block, making the "return usage();"
line dead code and ihex2fw silently ignoring unknown options.  Restore
this statement.

This bug was found by building with HOSTCC=clang and adding
-Wunreachable-code-return to HOSTCFLAGS.

Fixes: 2473238eac95 ("ihex: add support for CS:IP/EIP records")
Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 firmware/ihex2fw.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN firmware/ihex2fw.c~ihex-restore-missing-default-in-switch-statement firmware/ihex2fw.c
--- a/firmware/ihex2fw.c~ihex-restore-missing-default-in-switch-statement
+++ a/firmware/ihex2fw.c
@@ -86,6 +86,7 @@ int main(int argc, char **argv)
 		case 'j':
 			include_jump = 1;
 			break;
+		default:
 			return usage();
 		}
 	}
_

Patches currently in -mm which might be from nicolas.iooss_linux@m4x.org are

ihex-restore-missing-default-in-switch-statement.patch

