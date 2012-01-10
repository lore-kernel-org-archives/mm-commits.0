From: akpm@linux-foundation.org
Subject: - frv-duplicate-output_buffer-of-e03.patch removed from -mm tree
Date: Tue, 10 Jan 2012 15:45:52 -0800
Message-ID: <20120110234553.5E22E1001B2@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:39958 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab2AJXpy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 18:45:54 -0500
Received: by ggnk3 with SMTP id k3so21108ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 15:45:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, dhowells@redhat.com, jason.wessel@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: frv: duplicate output_buffer of E03
has been removed from the -mm tree.  Its filename was
     frv-duplicate-output_buffer-of-e03.patch

This patch was dropped because I don't know how to get this merged :(

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Roel Kluin <roel.kluin@gmail.com>
Subject: frv: duplicate output_buffer of E03

In the case of an error, output_buffer gets an E0X value.  E03 was set in
two.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/gdb-stub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/frv/kernel/gdb-stub.c~frv-duplicate-output_buffer-of-e03 arch/frv/kernel/gdb-stub.c
--- a/arch/frv/kernel/gdb-stub.c~frv-duplicate-output_buffer-of-e03
+++ a/arch/frv/kernel/gdb-stub.c
@@ -1936,7 +1936,7 @@ void gdbstub(int sigval)
 			}
 
 			if (temp >= 5) {
-				gdbstub_strcpy(output_buffer,"E03");
+				gdbstub_strcpy(output_buffer, "E02");
 				break;
 			}
 
@@ -1964,7 +1964,7 @@ void gdbstub(int sigval)
 			}
 
 			if (temp >= 5) {
-				gdbstub_strcpy(output_buffer,"E03");
+				gdbstub_strcpy(output_buffer, "E02");
 				break;
 			}
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
ceph-cifs-nfs-fuse-boolean-and-or-confusion.patch

