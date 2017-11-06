From: akpm@linux-foundation.org
Subject: + sysctl-add-register_sysctl-dummy-helper.patch added to -mm tree
Date: Mon, 06 Nov 2017 14:28:20 -0800
Message-ID: <5a00e204.0Rj3Gy0KbIWmpiVZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54106 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751829AbdKFW2W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2017 17:28:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, alex.bennee@linaro.org, catalin.marinas@arm.com, Dave.Martin@arm.com, ebiederm@xmission.com, keescook@chromium.org, mcgrof@kernel.org, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: add register_sysctl() dummy helper
has been added to the -mm tree.  Its filename is
     sysctl-add-register_sysctl-dummy-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysctl-add-register_sysctl-dummy-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysctl-add-register_sysctl-dummy-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: sysctl: add register_sysctl() dummy helper

register_sysctl() has been around for five years with commit fea478d4101a
("sysctl: Add register_sysctl for normal sysctl users") but now that arm64
started using it, I ran into a compile error:

arch/arm64/kernel/armv8_deprecated.c: In function 'register_insn_emulation_sysctl':
arch/arm64/kernel/armv8_deprecated.c:257:2: error: implicit declaration of function 'register_sysctl'

This adds a inline function like we already have for
register_sysctl_paths() and register_sysctl_table().

Link: http://lkml.kernel.org/r/20171106133700.558647-1-arnd@arndb.de
Fixes: 38b9aeb32fa7 ("arm64: Port deprecated instruction emulation to new sysctl interface")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Dave Martin <Dave.Martin@arm.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Alex Benne <alex.bennee@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN include/linux/sysctl.h~sysctl-add-register_sysctl-dummy-helper include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-add-register_sysctl-dummy-helper
+++ a/include/linux/sysctl.h
@@ -213,6 +213,11 @@ static inline struct ctl_table_header *r
 	return NULL;
 }
 
+static inline struct ctl_table_header *register_sysctl(const char *path, struct ctl_table *table)
+{
+	return NULL;
+}
+
 static inline void unregister_sysctl_table(struct ctl_table_header * table)
 {
 }
_

Patches currently in -mm which might be from arnd@arndb.de are

sysctl-add-register_sysctl-dummy-helper.patch
iopoll-avoid-wint-in-bool-context-warning.patch
initramfs-use-time64_t-timestamps.patch
pcmcia-badge4-avoid-unused-function-warning.patch

