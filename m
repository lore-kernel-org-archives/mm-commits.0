From: akpm@linux-foundation.org
Subject: [merged] ihex-restore-missing-default-in-switch-statement.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:16:47 -0700
Message-ID: <5535509f./pXvJi7WP4WoBgEy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbbDTTK0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:10:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.iooss_linux@m4x.org, broonie@opensource.wolfsonmicro.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: firmware/ihex2fw.c: restore missing default in switch statement
has been removed from the -mm tree.  Its filename was
     ihex-restore-missing-default-in-switch-statement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

