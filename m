From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?init-fix-misleading-this-architecture-does-not-have-kernel?=
 =?US-ASCII?Q?-memory-protection-message.patch?= removed from -mm tree
Date: Fri, 31 Jan 2020 15:21:04 -0800
Message-ID: <20200131232104.ij0inpqnG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXVF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:21:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, christophe.leroy@c-s.fr, keescook@chromium.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org


The patch titled
     Subject: init/main.c: fix misleading "This architecture does not have kernel memory protection" message
has been removed from the -mm tree.  Its filename was
     init-fix-misleading-this-architecture-does-not-have-kernel-memory-protection-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: init/main.c: fix misleading "This architecture does not have kernel memory protection" message

This message leads to thinking that memory protection is not implemented
for the said architecture, whereas absence of CONFIG_STRICT_KERNEL_RWX
only means that memory protection has not been selected at compile time.

Don't print this message when CONFIG_ARCH_HAS_STRICT_KERNEL_RWX is
selected by the architecture.  Instead, print "Kernel memory protection
not selected by kernel config."

Link: http://lkml.kernel.org/r/62477e446d9685459d4f27d193af6ff1bd69d55f.1578557581.git.christophe.leroy@c-s.fr
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/init/main.c~init-fix-misleading-this-architecture-does-not-have-kernel-memory-protection-message
+++ a/init/main.c
@@ -1104,6 +1104,11 @@ static void mark_readonly(void)
 	} else
 		pr_info("Kernel memory protection disabled.\n");
 }
+#elif defined(CONFIG_ARCH_HAS_STRICT_KERNEL_RWX)
+static inline void mark_readonly(void)
+{
+	pr_warn("Kernel memory protection not selected by kernel config.\n");
+}
 #else
 static inline void mark_readonly(void)
 {
_

Patches currently in -mm which might be from christophe.leroy@c-s.fr are
