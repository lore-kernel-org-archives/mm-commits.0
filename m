From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 28/35] docs: admin-guide: document the
 kernel.modprobe sysctl
Date: Fri, 10 Apr 2020 14:33:50 -0700
Message-ID: <20200410213350.o21mcrRmh%akpm@linux-foundation.org>
References: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbgDJVdw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 17:33:52 -0400
In-Reply-To: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ast@kernel.org, ebiggers@google.com, gregkh@linuxfoundation.org, jeffv@google.com, jeyu@kernel.org, keescook@chromium.org, linux-mm@kvack.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, neilb@suse.com, torvalds@linux-foundation.org

From: Eric Biggers <ebiggers@google.com>
Subject: docs: admin-guide: document the kernel.modprobe sysctl

Document the kernel.modprobe sysctl in the same place that all the other
kernel.* sysctls are documented.  Make sure to mention how to use this
sysctl to completely disable module autoloading, and how this sysctl
relates to CONFIG_STATIC_USERMODEHELPER.

[ebiggers@google.com: v5]
  Link: http://lkml.kernel.org/r/20200318230515.171692-4-ebiggers@kernel.org
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

 Documentation/admin-guide/sysctl/kernel.rst |   21 ++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/Documentation/admin-guide/sysctl/kernel.rst~docs-admin-guide-document-the-kernelmodprobe-sysctl
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -446,6 +446,27 @@ Notes:
      successful IPC object allocation. If an IPC object allocation syscall
      fails, it is undefined if the value remains unmodified or is reset to -1.
 
+modprobe:
+=========
+
+The path to the usermode helper for autoloading kernel modules, by
+default "/sbin/modprobe".  This binary is executed when the kernel
+requests a module.  For example, if userspace passes an unknown
+filesystem type to mount(), then the kernel will automatically request
+the corresponding filesystem module by executing this usermode helper.
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
 
 nmi_watchdog
 ============
_
