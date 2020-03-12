From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 docs-admin-guide-document-the-kernelmodprobe-sysctl.patch added to -mm tree
Date: Thu, 12 Mar 2020 15:29:46 -0700
Message-ID: <20200312222946.IirIyx_KV%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727064AbgCLW3s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Mar 2020 18:29:48 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, ebiggers@google.com, gregkh@linuxfoundation.org, jeffv@google.com, jeyu@kernel.org, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, neilb@suse.com


The patch titled
     Subject: docs: admin-guide: document the kernel.modprobe sysctl
has been added to the -mm tree.  Its filename is
     docs-admin-guide-document-the-kernelmodprobe-sysctl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/docs-admin-guide-document-the-kernelmodprobe-sysctl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/docs-admin-guide-document-the-kernelmodprobe-sysctl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: docs: admin-guide: document the kernel.modprobe sysctl

Document the kernel.modprobe sysctl in the same place that all the other
kernel.* sysctls are documented.  Make sure to mention how to use this
sysctl to completely disable module autoloading, and how this sysctl
relates to CONFIG_STATIC_USERMODEHELPER.

Link: http://lkml.kernel.org/r/20200312202552.241885-4-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |   25 +++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~docs-admin-guide-document-the-kernelmodprobe-sysctl
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -49,7 +49,7 @@ show up in /proc/sys/kernel:
 - kexec_load_disabled
 - kptr_restrict
 - l2cr                        [ PPC only ]
-- modprobe                    ==> Documentation/debugging-modules.txt
+- modprobe
 - modules_disabled
 - msg_next_id		      [ sysv ipc ]
 - msgmax
@@ -444,6 +444,29 @@ l2cr: (PPC only)
 This flag controls the L2 cache of G3 processor boards. If
 0, the cache is disabled. Enabled if nonzero.
 
+modprobe:
+=========
+
+The path to the usermode helper for autoloading kernel modules, by
+default "/sbin/modprobe".  This binary is executed when the kernel
+requests a module.  For example, if userspace passes an unknown
+filesystem type "foo" to mount(), then the kernel will automatically
+request the module "fs-foo.ko" by executing this usermode helper.
+This usermode helper should insert the needed module into the kernel.
+
+This sysctl only affects module autoloading.  It has no effect on the
+ability to explicitly insert modules.
+
+If this sysctl is set to the empty string, then module autoloading is
+completely disabled.  The kernel will not try to execute a usermode
+helper at all, nor will it call the kernel_module_request LSM hook.
+
+If CONFIG_STATIC_USERMODEHELPER=y is set in the kernel configuration,
+then the configured static usermode helper overrides this sysctl,
+except that the empty string is still accepted to completely disable
+module autoloading as described above.
+
+Also see Documentation/debugging-modules.txt.
 
 modules_disabled:
 =================
_

Patches currently in -mm which might be from ebiggers@google.com are

kmod-make-request_module-return-an-error-when-autoloading-is-disabled.patch
fs-filesystemsc-downgrade-user-reachable-warn_once-to-pr_warn_once.patch
docs-admin-guide-document-the-kernelmodprobe-sysctl.patch
selftests-kmod-test-disabling-module-autoloading.patch
