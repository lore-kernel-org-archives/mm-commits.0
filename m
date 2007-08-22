From: akpm@linux-foundation.org
Subject: - ver_linux-is.patch removed from -mm tree
Date: Tue, 21 Aug 2007 17:03:28 -0700
Message-ID: <200708220008.l7M08ab0018236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54723 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751971AbXHVAJU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Aug 2007 20:09:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, jesper.juhl@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ver_linux is [censored]
has been removed from the -mm tree.  Its filename was
     ver_linux-is.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: ver_linux is [censored]
From: Alexey Dobriyan <adobriyan@sw.ru>

Commit 4a645d5ea65baaa5736bcb566673bf4a351b2ad8 broke ver_linux
on etch which glibc has 3-digit version number. Patch replaces awk
wanking with more robust sed wanking.

Tested on gentoo, etch, centos 4.2.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Tested-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/ver_linux |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN scripts/ver_linux~ver_linux-is scripts/ver_linux
--- a/scripts/ver_linux~ver_linux-is
+++ a/scripts/ver_linux
@@ -65,9 +65,9 @@ isdnctrl 2>&1 | grep version | awk \
 showmount --version 2>&1 | grep nfs-utils | awk \
 'NR==1{print "nfs-utils             ", $NF}'
 
-ls -l `ldd /bin/sh | awk '/libc/{print $3}'` | sed \
--e 's/\.so$//' | sed -e 's/>//' | \
-awk -F'[.-]' '{print "Linux C Library        "$(NF-1)"."$NF}'
+echo -n "Linux C Library        "
+ls -l `ldd /bin/sh | awk '/libc/{print $3}'` 	| \
+	sed -e 's/.*libc-//' -e 's/\.so$//'
 
 ldd -v > /dev/null 2>&1 && ldd -v || ldd --version |head -n 1 | awk \
 'NR==1{print "Dynamic linker (ldd)  ", $NF}'
_

Patches currently in -mm which might be from adobriyan@sw.ru are

ver_linux-is.patch
consolidate-ptrace_detach.patch
use-list_head-in-binfmt-handling-update.patch
make-unregister_binfmt-return-void.patch
slab_panic-more-proc-posix-timers-shmem.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2.patch
tweak-proc-ipmi-removal.patch
sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
sysctl-factor-out-sysctl_data.patch
sysctl-error-on-bad-sysctl-tables.patch
sysctl-update-sysctl_check_table.patch
sysct-mqueue-remove-the-binary-sysctl-numbers.patch
sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-x86_64-remove-unnecessary-binary-paths.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
single_open-seq_release-leak-diagnostics.patch
