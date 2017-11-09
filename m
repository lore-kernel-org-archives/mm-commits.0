From: akpm@linux-foundation.org
Subject: [patch 1/2] sysctl: add register_sysctl() dummy helper
Date: Thu, 09 Nov 2017 13:38:18 -0800
Message-ID: <5a04caca.LBPT+18qEzh88Zm1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39112 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752952AbdKIViU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Nov 2017 16:38:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, arnd@arndb.de, alex.bennee@linaro.org, catalin.marinas@arm.com, Dave.Martin@arm.com, ebiederm@xmission.com, keescook@chromium.org, mcgrof@kernel.org, tglx@linutronix.de, will.deacon@arm.com

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
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
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
