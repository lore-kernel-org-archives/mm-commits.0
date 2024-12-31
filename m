Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CF54C7D
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 00:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735605737; cv=none; b=FxcINKiMm4ATJHlX8rrki6QrDkBFTSdmbjWmWDJ/f++FoNYVKIjFNsYJ+7B2x0APJrta3es5VN8VorK6vIcxwMbbYRQ/SWJxNz/ZqGr4aiBXjUS0DOFGMYB3DmqGnnBYadkhasV8ShFRoaVwY01NA7a+Zb1pxwtaBus+u7+gM/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735605737; c=relaxed/simple;
	bh=jxboJ9riGLtDkgZROCjGTdOb4xLDbFAqBGl0sOxpr9c=;
	h=Date:To:From:Subject:Message-Id; b=l1CdxMp7B67pUopwqmmJRJOJkSF4xfkU9V174jPCLnJabnV1uoQPgG2+8MacGOSgdGJ2XajYkXz7HpHY6L7t/rKjMSB/8rXcUXiP6BrvKO2qvKQzsZmRw7CRG0WVPNtMNqW8ICzsuZUP8w6CS9B0uKStzEJuJ0bPTtoWvRzIhZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2KSDEgUN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2KSDEgUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AE2C4CED0;
	Tue, 31 Dec 2024 00:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735605736;
	bh=jxboJ9riGLtDkgZROCjGTdOb4xLDbFAqBGl0sOxpr9c=;
	h=Date:To:From:Subject:From;
	b=2KSDEgUNhgYPAyefz5yMqXYWDCAtnZvM02EFn5DlOjlf781tFpFT8Xah6EShZr1h4
	 iMdlThcSXraEj7ylmVvHeyPTfRpqVTzQzvTGDLpj5oDCvbB7K/CvY3fgea883n0BMl
	 1HdWg50vGvzMGGFkqM6zEq8jnoqGRXp44ywVnhco=
Date: Mon, 30 Dec 2024 16:42:16 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,song@kernel.org,shuah@kernel.org,samitolvanen@google.com,rostedt@goodmis.org,rmoar@google.com,richard@nod.at,pmladek@suse.com,petr.pavlu@suse.com,peterz@infradead.org,mingo@redhat.com,mhiramat@kernel.org,mcgrof@kernel.org,mbenes@suse.cz,mark.rutland@arm.com,luto@kernel.org,kirill.shutemov@linux.intel.com,jpoimboe@kernel.org,johannes@sipsolutions.net,joe.lawrence@redhat.com,jikos@kernel.org,jason.wessel@windriver.com,hpa@zytor.com,dianders@chromium.org,davidgow@google.com,dave.hansen@linux.intel.com,danielt@kernel.org,da.gomez@samsung.com,brendan.higgins@linux.dev,bp@alien8.de,anton.ivanov@cambridgegreys.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-pat-drop-duplicate-variable-in-cpa_flush.patch added to mm-unstable branch
Message-Id: <20241231004216.B6AE2C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm/pat: drop duplicate variable in cpa_flush()
has been added to the -mm mm-unstable branch.  Its filename is
     x86-mm-pat-drop-duplicate-variable-in-cpa_flush.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-pat-drop-duplicate-variable-in-cpa_flush.patch

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
Subject: x86/mm/pat: drop duplicate variable in cpa_flush()
Date: Fri, 27 Dec 2024 09:28:19 +0200

There is a 'struct cpa_data *data' parameter in cpa_flush() that is
assigned to a local 'struct cpa_data *cpa' variable.

Rename the parameter from 'data' to 'cpa' and drop declaration of the
local 'cpa' variable.

Link: https://lkml.kernel.org/r/20241227072825.1288491-3-rppt@kernel.org
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

 arch/x86/mm/pat/set_memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/mm/pat/set_memory.c~x86-mm-pat-drop-duplicate-variable-in-cpa_flush
+++ a/arch/x86/mm/pat/set_memory.c
@@ -396,9 +396,8 @@ static void __cpa_flush_tlb(void *data)
 		flush_tlb_one_kernel(fix_addr(__cpa_addr(cpa, i)));
 }
 
-static void cpa_flush(struct cpa_data *data, int cache)
+static void cpa_flush(struct cpa_data *cpa, int cache)
 {
-	struct cpa_data *cpa = data;
 	unsigned int i;
 
 	BUG_ON(irqs_disabled() && !early_boot_irqs_disabled);
_

Patches currently in -mm which might be from rppt@kernel.org are

x86-mm-pat-cpa-test-fix-length-for-cpa_array-test.patch
x86-mm-pat-drop-duplicate-variable-in-cpa_flush.patch
execmem-add-api-for-temporal-remapping-as-rw-and-restoring-rox-afterwards.patch
module-introduce-module_state_gone.patch
modules-switch-to-execmem-api-for-remapping-as-rw-and-restoring-rox.patch
revert-x86-module-prepare-module-loading-for-rox-allocations-of-text.patch
module-drop-unused-module_writable_address.patch

