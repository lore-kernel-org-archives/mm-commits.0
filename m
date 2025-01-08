Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED562594B3
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 04:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736311015; cv=none; b=C/0pboLtAgaDW6wie27C68AHJANKlzcVfZAOFCaCWvIWm6v1DkksuQ/6Jota+yn3SKoDNIBp+9ER3O5d7mdTEaNCZRQkckkRlduWC7yws6BUdQG2UIdrihjmoLS9WDIs7NRV69SlWrrTfsoXLIguIGJFbFZlRdsW7spzg4/X7qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736311015; c=relaxed/simple;
	bh=e2q00Q7urAGB/+10cRo0Ae/iKdr6BSzvH3VxynMHL4s=;
	h=Date:To:From:Subject:Message-Id; b=Qy6It23olFncHT4Jfq9QvL+lmgI4XmO++663FVV8lWDOXwnVSWRsfNajFzMid257H2ZbJR+o7LYc5jKXot1Rdgi3G2DG6Poz6k6L/18wef2L1G0bkcV68V7xOzJQjoHCsGkW5TgPuF0m3+eClxsUchmbfkWIKO2aNINh+dku+FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yi7gis16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yi7gis16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A46C4CED0;
	Wed,  8 Jan 2025 04:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736311015;
	bh=e2q00Q7urAGB/+10cRo0Ae/iKdr6BSzvH3VxynMHL4s=;
	h=Date:To:From:Subject:From;
	b=yi7gis16/+SOtuu2ZeZucE8eSJyTaz/Bfcy/SBXpCua50+LJHzYuoETSjtt3PDPHv
	 xGC/023B80JJuwQlX6YJJ+Fjayjr+VL2n/C0DAE2G/7Xk/8atGGHUJcQJ/psZQ4D1S
	 +kU2Eg/64G/9hVW/CdWo85G7oSYQFYZudsAq1C3I=
Date: Tue, 07 Jan 2025 20:36:54 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pmladek@suse.com,mmaslanka@google.com,mcgrof@kernel.org,jpoimboe@kernel.org,joe.lawrence@redhat.com,petr.pavlu@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + module-fix-writing-of-livepatch-relocations-in-rox-text.patch added to mm-unstable branch
Message-Id: <20250108043655.13A46C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: module: fix writing of livepatch relocations in ROX text
has been added to the -mm mm-unstable branch.  Its filename is
     module-fix-writing-of-livepatch-relocations-in-rox-text.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/module-fix-writing-of-livepatch-relocations-in-rox-text.patch

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
From: Petr Pavlu <petr.pavlu@suse.com>
Subject: module: fix writing of livepatch relocations in ROX text
Date: Tue, 7 Jan 2025 16:34:57 +0100

A livepatch module can contain a special relocation section
.klp.rela.<objname>.<secname> to apply its relocations at the appropriate
time and to additionally access local and unexported symbols.  When
<objname> points to another module, such relocations are processed
separately from the regular module relocation process.  For instance, only
when the target <objname> actually becomes loaded.

With CONFIG_STRICT_MODULE_RWX, when the livepatch core decides to apply
these relocations, their processing results in the following bug:

[   25.827238] BUG: unable to handle page fault for address: 00000000000012ba
[   25.827819] #PF: supervisor read access in kernel mode
[   25.828153] #PF: error_code(0x0000) - not-present page
[   25.828588] PGD 0 P4D 0
[   25.829063] Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
[   25.829742] CPU: 2 UID: 0 PID: 452 Comm: insmod Tainted: G O  K    6.13.0-rc4-00078-g059dd502b263 #7820
[   25.830417] Tainted: [O]=OOT_MODULE, [K]=LIVEPATCH
[   25.830768] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-20220807_005459-localhost 04/01/2014
[   25.831651] RIP: 0010:memcmp+0x24/0x60
[   25.832190] Code: [...]
[   25.833378] RSP: 0018:ffffa40b403a3ae8 EFLAGS: 00000246
[   25.833637] RAX: 0000000000000000 RBX: ffff93bc81d8e700 RCX: ffffffffc0202000
[   25.834072] RDX: 0000000000000000 RSI: 0000000000000004 RDI: 00000000000012ba
[   25.834548] RBP: ffffa40b403a3b68 R08: ffffa40b403a3b30 R09: 0000004a00000002
[   25.835088] R10: ffffffffffffd222 R11: f000000000000000 R12: 0000000000000000
[   25.835666] R13: ffffffffc02032ba R14: ffffffffc007d1e0 R15: 0000000000000004
[   25.836139] FS:  00007fecef8c3080(0000) GS:ffff93bc8f900000(0000) knlGS:0000000000000000
[   25.836519] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   25.836977] CR2: 00000000000012ba CR3: 0000000002f24000 CR4: 00000000000006f0
[   25.837442] Call Trace:
[   25.838297]  <TASK>
[   25.841083]  __write_relocate_add.constprop.0+0xc7/0x2b0
[   25.841701]  apply_relocate_add+0x75/0xa0
[   25.841973]  klp_write_section_relocs+0x10e/0x140
[   25.842304]  klp_write_object_relocs+0x70/0xa0
[   25.842682]  klp_init_object_loaded+0x21/0xf0
[   25.842972]  klp_enable_patch+0x43d/0x900
[   25.843572]  do_one_initcall+0x4c/0x220
[   25.844186]  do_init_module+0x6a/0x260
[   25.844423]  init_module_from_file+0x9c/0xe0
[   25.844702]  idempotent_init_module+0x172/0x270
[   25.845008]  __x64_sys_finit_module+0x69/0xc0
[   25.845253]  do_syscall_64+0x9e/0x1a0
[   25.845498]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   25.846056] RIP: 0033:0x7fecef9eb25d
[   25.846444] Code: [...]
[   25.847563] RSP: 002b:00007ffd0c5d6de8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[   25.848082] RAX: ffffffffffffffda RBX: 000055b03f05e470 RCX: 00007fecef9eb25d
[   25.848456] RDX: 0000000000000000 RSI: 000055b001e74e52 RDI: 0000000000000003
[   25.848969] RBP: 00007ffd0c5d6ea0 R08: 0000000000000040 R09: 0000000000004100
[   25.849411] R10: 00007fecefac7b20 R11: 0000000000000246 R12: 000055b001e74e52
[   25.849905] R13: 0000000000000000 R14: 000055b03f05e440 R15: 0000000000000000
[   25.850336]  </TASK>
[   25.850553] Modules linked in: deku(OK+) uinput
[   25.851408] CR2: 00000000000012ba
[   25.852085] ---[ end trace 0000000000000000 ]---

The problem is that the .klp.rela.<objname>.<secname> relocations are
processed after the module was already formed and mod->rw_copy was reset. 
However, the code in __write_relocate_add() calls
module_writable_address() which translates the target address 'loc' still
to 'loc + (mem->rw_copy - mem->base)', with mem->rw_copy now being 0.

Fix the problem by returning directly 'loc' in module_writable_address()
when the module is already formed.  Function __write_relocate_add() knows
to use text_poke() in such a case.

Link: https://lkml.kernel.org/r/20250107153507.14733-1-petr.pavlu@suse.com
Fixes: 0c133b1e78cd ("module: prepare to handle ROX allocations for text")
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Reported-by: Marek Maslanka <mmaslanka@google.com>
Closes: https://lore.kernel.org/linux-modules/CAGcaFA2hdThQV6mjD_1_U+GNHThv84+MQvMWLgEuX+LVbAyDxg@mail.gmail.com/
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/module.h~module-fix-writing-of-livepatch-relocations-in-rox-text
+++ a/include/linux/module.h
@@ -773,7 +773,8 @@ void *__module_writable_address(struct m
 
 static inline void *module_writable_address(struct module *mod, void *loc)
 {
-	if (!IS_ENABLED(CONFIG_ARCH_HAS_EXECMEM_ROX) || !mod)
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_EXECMEM_ROX) || !mod ||
+	    mod->state != MODULE_STATE_UNFORMED)
 		return loc;
 	return __module_writable_address(mod, loc);
 }
_

Patches currently in -mm which might be from petr.pavlu@suse.com are

module-fix-writing-of-livepatch-relocations-in-rox-text.patch

