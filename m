From: akpm@linux-foundation.org
Subject: + revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch added to -mm tree
Date: Tue, 23 Oct 2012 15:13:37 -0700
Message-ID: <20121023221337.81CE9100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:42488 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376Ab2JWWNi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 18:13:38 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so549885yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 15:13:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: revert-tools-testing-selftests-epoll-test_epollc-fix-build
has been added to the -mm tree.  Its filename is
     revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert-tools-testing-selftests-epoll-test_epollc-fix-build

To include in revert-epoll-support-for-disabling-items-and-a-self-test-app.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/epoll/test_epoll.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN tools/testing/selftests/epoll/test_epoll.c~revert-tools-testing-selftests-epoll-test_epollc-fix-build tools/testing/selftests/epoll/test_epoll.c
--- a/tools/testing/selftests/epoll/test_epoll.c~revert-tools-testing-selftests-epoll-test_epollc-fix-build
+++ a/tools/testing/selftests/epoll/test_epoll.c
@@ -162,14 +162,14 @@ void *write_thread_function(void *functi
 	int index;
 	struct write_thread_data *thread_data =
 		(struct write_thread_data *)function_data;
-	while (!thread_data->stop)
+	while (!write_thread_data->stop)
 		for (index = 0;
 		     !thread_data->stop && (index < thread_data->n_fds);
 		     ++index)
 			if ((write(thread_data->fds[index], &data, 1) < 1) &&
 				(errno != EAGAIN) &&
 				(errno != EWOULDBLOCK)) {
-				thread_data->status = errno;
+				write_thread_data->status = errno;
 				return;
 			}
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
drivers-edac-amd64_edacc-__amd64_set_scrub_rate-avoid-overindexing-scrubrates.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
procfs-add-vmflags-field-in-smaps-output-v3-fix.patch
random-fix-debug-format-strings-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

