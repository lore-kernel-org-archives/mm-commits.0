Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9302D4A21
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 00:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735605760; cv=none; b=djGFa0JJd3OfCrLRfZXShXN6TwDai5/zTeogVaOktUSddBF/5fHYB2bZeKwjewLcZ6lRCTxOnqPiqjtlbVCaPzRkv5Q+gpk2PAcOdZ3RZ2t2amGZb69zVjqKyEM7DReZU9u/sPa5AbqL3yZwsq+V3Zo9EHBaobei2b8IbBdTujc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735605760; c=relaxed/simple;
	bh=JJuOSVqf0yvdTk3nE5cro2qvc8UO7eFvXLLTBWfDnjs=;
	h=Date:To:From:Subject:Message-Id; b=SGi9nYzBxJ7vcmv+qvoYGhnst7c845I+/s3S2l0Se9+1bpj0wbvHu8IIcTsDP7Q3Q7Srlpm1KvAA7FfJJZ6HpaX7/uiZftYanMIQjYw8MZJJlQEBHBcgVAnX5YwaYvQkjrQrpoAFsVxV5Ui9YFVaZ6IRAtTONuY6YTCoKlL7+FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ja/g6LqX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ja/g6LqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F75C4CED0;
	Tue, 31 Dec 2024 00:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735605760;
	bh=JJuOSVqf0yvdTk3nE5cro2qvc8UO7eFvXLLTBWfDnjs=;
	h=Date:To:From:Subject:From;
	b=ja/g6LqXuQ1+lLRm8ya1SDXr/Y+5xUmG7pw6cFxJkRphJDhFV6nmlNkoWK8aywBXv
	 hnrZ1iT+R0Feeuysc4PMQDWxUSV0xdxVnNDouB7q+5D9o1O799ph/I54fCN3RWL2+8
	 tjCxzEw8UowlqtyNqMnipdBtj/Gta7m+gkaUvsYs=
Date: Mon, 30 Dec 2024 16:42:39 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,song@kernel.org,shuah@kernel.org,samitolvanen@google.com,rostedt@goodmis.org,rmoar@google.com,richard@nod.at,pmladek@suse.com,petr.pavlu@suse.com,peterz@infradead.org,mingo@redhat.com,mhiramat@kernel.org,mcgrof@kernel.org,mbenes@suse.cz,mark.rutland@arm.com,luto@kernel.org,kirill.shutemov@linux.intel.com,jpoimboe@kernel.org,johannes@sipsolutions.net,joe.lawrence@redhat.com,jikos@kernel.org,jason.wessel@windriver.com,hpa@zytor.com,dianders@chromium.org,davidgow@google.com,dave.hansen@linux.intel.com,danielt@kernel.org,da.gomez@samsung.com,brendan.higgins@linux.dev,bp@alien8.de,anton.ivanov@cambridgegreys.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + module-drop-unused-module_writable_address.patch added to mm-unstable branch
Message-Id: <20241231004240.26F75C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: module: drop unused module_writable_address()
has been added to the -mm mm-unstable branch.  Its filename is
     module-drop-unused-module_writable_address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/module-drop-unused-module_writable_address.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: module: drop unused module_writable_address()
Date: Fri, 27 Dec 2024 09:28:25 +0200

module_writable_address() is unused and can be removed.

Link: https://lkml.kernel.org/r/20241227072825.1288491-9-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Daniel Thompson <danielt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Gow <davidgow@google.com>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Rae Moar <rmoar@google.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |   10 ----------
 1 file changed, 10 deletions(-)

--- a/include/linux/module.h~module-drop-unused-module_writable_address
+++ a/include/linux/module.h
@@ -774,11 +774,6 @@ static inline bool is_livepatch_module(s
 
 void set_module_sig_enforced(void);
 
-static inline void *module_writable_address(struct module *mod, void *loc)
-{
-	return loc;
-}
-
 #else /* !CONFIG_MODULES... */
 
 static inline struct module *__module_address(unsigned long addr)
@@ -886,11 +881,6 @@ static inline bool module_is_coming(stru
 {
 	return false;
 }
-
-static inline void *module_writable_address(struct module *mod, void *loc)
-{
-	return loc;
-}
 #endif /* CONFIG_MODULES */
 
 #ifdef CONFIG_SYSFS
_

Patches currently in -mm which might be from rppt@kernel.org are

x86-mm-pat-cpa-test-fix-length-for-cpa_array-test.patch
x86-mm-pat-drop-duplicate-variable-in-cpa_flush.patch
execmem-add-api-for-temporal-remapping-as-rw-and-restoring-rox-afterwards.patch
module-introduce-module_state_gone.patch
modules-switch-to-execmem-api-for-remapping-as-rw-and-restoring-rox.patch
revert-x86-module-prepare-module-loading-for-rox-allocations-of-text.patch
module-drop-unused-module_writable_address.patch

