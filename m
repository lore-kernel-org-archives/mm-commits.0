From: akpm@linux-foundation.org
Subject: [patch 4/4] tools/objtool/Makefile: don't assume sync-check.sh is executable
Date: Fri, 12 Jan 2018 16:53:17 -0800
Message-ID: <5a59587d.aAz+6r+fdahLjXII%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46258 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965265AbeAMAxT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 Jan 2018 19:53:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jpoimboe@redhat.com, mingo@kernel.org, nicolasbock@gentoo.org

From: Andrew Morton <akpm@linux-foundation.org>
Subject: tools/objtool/Makefile: don't assume sync-check.sh is executable

patch(1) loses the x bit.  So if a user follows our patching instructions
in Documentation/admin-guide/README.rst, their kernel will not compile.

Fixes: 3bd51c5a371de ("objtool: Move kernel headers/code sync check to a script")
Reported-by: Nicolas Bock <nicolasbock@gentoo.org>
Reported-by Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/objtool/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/objtool/Makefile~tools-objtool-makefile-dont-assume-sync-checksh-is-executable tools/objtool/Makefile
--- a/tools/objtool/Makefile~tools-objtool-makefile-dont-assume-sync-checksh-is-executable
+++ a/tools/objtool/Makefile
@@ -46,7 +46,7 @@ $(OBJTOOL_IN): fixdep FORCE
 	@$(MAKE) $(build)=objtool
 
 $(OBJTOOL): $(LIBSUBCMD) $(OBJTOOL_IN)
-	@./sync-check.sh
+	@$(CONFIG_SHELL) ./sync-check.sh
 	$(QUIET_LINK)$(CC) $(OBJTOOL_IN) $(LDFLAGS) -o $@
 
 
_
