Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9C43A5449;
	Tue,  8 Sep 2026 22:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788908265; cv=none; b=CNlsAeLXtGbSdQCKFblweDalDXaeSKdOZcxy92vr+qeRQWJbHR0blnjmU1CYq04naStBZXHI3JtHf0T+BfHsJcu/1fs73b6YQNBE+/aegLqmfbYUmyg2xwWU/PzEYzLcS2boGGlpQmaSyPOh2gHD1/uJX4W+JVncDnimbY5SHmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788908265; c=relaxed/simple;
	bh=NQ/8z6WQwtaNm4Y+2hkcL6a2MAJWrjTVR42bWSF+AKI=;
	h=Date:To:From:Subject:Message-Id; b=j2dQ95VlshmB3DO0fth+uAwClEfat0GivPjyDoOczy9k5KMWhFawbpigSS1WakUr2ImtTND+15keV7UrI4mI/6pqFhuqUvCcwYAT3vS2TkZQeh7S8JHvzER9lp5I4sGboyFFf8Bog8LFqz75z4/nsVJdVuKixSEM/HvMla127mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QwKkF/Q7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QwKkF/Q7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF6E1F00A3F;
	Tue,  8 Sep 2026 22:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788908261;
	bh=HCFdgIxcmrVDlnFdwyokw3hSpj5uPTqDbqObuuZHvoE=;
	h=Date:To:From:Subject;
	b=QwKkF/Q7yTcmvSA/Hkfrgp4uoAAY0r/GC+/z9FSKADLaBZKhC1Rq/LC2bW14RLW0j
	 tEzPzRrw91rnmn5mJOtDuV69DlI0chYF7SmWHl1/TplUPWFkKWiJtUcd8kuYpUVtd2
	 zPAjGcM9CaKgGmLdNWwydQV/nM1jwwiA9fgJXHuE=
Date: Tue, 08 Sep 2026 15:57:41 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sashiko-bot@kernel.org,samitolvanen@google.com,petr.pavlu@suse.com,peterz@infradead.org,ojeda@kernel.org,mhiramat@kernel.org,mcgrof@kernel.org,gregkh@linuxfoundation.org,arnd@arndb.de,atomlin@atomlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + module-treat-dashes-and-underscores-interchangeably-in-module_blacklist.patch added to mm-nonmm-unstable branch
Message-Id: <20260908225741.BEF6E1F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: module: treat dashes and underscores interchangeably in module_blacklist
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     module-treat-dashes-and-underscores-interchangeably-in-module_blacklist.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/module-treat-dashes-and-underscores-interchangeably-in-module_blacklist.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Aaron Tomlin <atomlin@atomlin.com>
Subject: module: treat dashes and underscores interchangeably in module_blacklist
Date: Tue, 8 Sep 2026 16:32:28 -0400

Patch series "module: Extend module_blacklist parameter to built-in
modules", v11.

This patch series extends the module_blacklist= command-line parameter
(and its modern alias module_denylist=) to intercept built-in modules
during early boot.  Currently, when a driver is compiled statically into
the kernel (=y), the parameter is silently ignored, precluding
administrators from suppressing problematic drivers during boot-time
disaster recovery.  This series resolves that discrepancy by mapping
built-in modules to their initialisation routines via transient metadata
that is freed post-boot, providing a predictable and consistent
administrative interface regardless of whether a driver is built as a
loadable module or compiled into the kernel image.  Below is a detailed
breakdown of the motivation, operational rationale, and concrete use cases
addressed by this work.

1.  The Core Problem and User Experience Gap
============================================

Today, module_blacklist= works strictly on loadable modules.  When a user
or system administrator encounters a driver bug, hang during device probe,
or hardware fault during boot, the natural and widely documented remedy is
to pass module_blacklist=[driver] via the bootloader (GRUB, systemd-boot,
etc.).  However, if that driver is built into the kernel, the parameter is
silently ignored.  The kernel proceeds to run the driver's initialisation
routine anyway, leading to the same panic, hang, or hardware misbehaviour.
>From the user's standpoint, whether a driver was packaged by their
distribution or built by their provider as =m or =y is an internal
implementation detail.  Having module_blacklist= silently fail solely
based on compilation configuration violates the principle of least
surprise and complicates system recovery.

2.  Why initcall_blacklist= is not an adequate substitute
=========================================================

The kernel does provide initcall_blacklist=, but it is impractical for
general users, sysadmins, and automated fleet management tools for several
reasons:

    Obscure symbol names

        - initcall_blacklist= requires the exact function name of the
          initcall (e.g., snb_pci_uarch_init and e1000_init_module). Users
          typically know the module name, not the internal function name.

    Internal instability

        - Initcall function names are internal kernel implementation
          details. They change across kernel releases, refactors, or macro
          rewrites, making it impossible to write stable bootloader
          configurations or recovery documentation across multiple kernel
          versions.

    Mangled names (Rust)

        - For modern drivers written in Rust, the initcall symbol names are
          compiler-mangled symbols (e.g. "_RNvX"), making
          initcall_blacklist= practically impossible for a human user to
          specify manually at a boot prompt.

module_blacklist= (or module_denylist=) resolves this by allowing users to
specify the canonical, user-facing module name (KBUILD_MODNAME) that they
already know.

3.  Concrete use cases
======================

    A.  Disaster recovery and triage on production systems

        When a kernel update introduces a regression in a built-in driver
        (e.g., a storage controller), administrators need a way to bypass
        that driver at boot time to get the system into a usable emergency
        shell or collect diagnostic logs, without having to rebuild the
        kernel on another machine.

    B.  Monolithic/Hardened environments (CONFIG_MODULES=n)

        In security-sensitive environments, kernels are frequently compiled
        without loadable module support (CONFIG_MODULES=n) to eliminate
        module loading attack vectors. On these systems, all drivers are
        built-in. If a hardware erratum or firmware bug triggers a hang in
        a built-in driver, administrators previously had no
        module-name-based mechanism to disable the offending driver.

    C. Hardware Errata and Conflicting Devices

       On systems with buggy firmware or conflicting device IDs where two
       drivers attempt to bind to the same hardware, users can prevent the
       conflicting built-in driver from initializing without patching and
       recompiling the entire kernel image.

4. Implementation and Overhead Considerations
=============================================

We took great care to ensure this change introduces virtually zero runtime
overhead:

    Scoped to module_init()

        - Only built-in drivers that explicitly use module_init() are
          tracked. Core kernel subsystems using core_initcall(),
          subsys_initcall(), etc. are unaffected.

    Zero Resident Memory

        - The metadata table (.initcall.modnames) and the module name
          strings (.init.rodata) are placed entirely in init sections and
          are completely freed from memory after boot via free_initmem().

    Fast Path

        - During boot, if neither module_blacklist= nor module_denylist=
          was supplied on the kernel command line, the lookup is bypassed
          entirely.

In summary, this patch brings parity between modular and built-in drivers,
removes a pain point in boot-time disaster recovery, and provides users
with a predictable, consistent interface.

Following review feedback, the implementation is structured as three
separate changes to isolate a pre-existing bugfix, decouple the
introduction of the new feature, and handle the terminology renaming:

    1.  The first patch is a standalone prerequisite bugfix addressing a
        pre-existing flaw in the module blacklisting logic where hyphens
        and underscores are not treated interchangeably. Because the kernel
        build system normalises module names to use underscores (e.g.
        "my_module"), specifying a module with hyphens on the command line
        (such as "module_blacklist=my-module") failed to match due to a
        strict byte-for-byte memcmp(). It replaces memcmp() with
        parameqn(), carries a Fixes: tag, and is CC'd to stable.

    2.  The second patch extends the "module_blacklist=" parameter to
        built-in modules using the original blacklist terminology. It
        introduces the ".initcall.modnames" section to map initcall
        function pointers to their associated KBUILD_MODNAME strings
        (restricted only to module_init() invocations to save memory and
        avoid matching core kernel subsystems). It also restricts the check
        to a boot-time __init wrapper to eliminate Use-After-Free (UAF) and
        Spectre v1 vulnerability risks when loading dynamic modules at
        runtime, and adds a fast-path check to eliminate lookup overhead
        when the parameter is not in use.

    3   The third patch renames the variables and helper functions to adopt
        the preferred "module_denylist=" and module_is_denylisted()
        terminology in the codebase. To preserve the existing user-space
        ABI, "module_blacklist=" is kept as a legacy alias pointing to the
        same module_denylist variable.


This patch (of 3):

The "module_blacklist=" command-line parameter allows administrators to
prevent specific modules from loading by specifying a comma-separated list
of module names.  The blacklisted() helper checks candidate modules
against this list using a strict byte-for-byte comparison via memcmp().

However, the kernel build system normalises module names to use
underscores (e.g., "my_module"), whereas administrators and user-space
utilities may use hyphens (e.g., "my-module") interchangeably.

Because of the strict memcmp(), specifying a module name with a hyphen on
the kernel command line (e.g., "module_blacklist=my-module") fails to
match the internal module name ("my_module").  Consequently, the module is
loaded despite having been explicitly blacklisted, defeating the intended
administrative mitigation.

Replace memcmp() with parameqn(), which treats dashes and underscores as
equivalent.  This ensures that module names match correctly regardless of
whether hyphens or underscores are supplied, matching standard kernel
parameter and modprobe behaviour.

Link: https://lore.kernel.org/20260908203230.401020-1-atomlin@atomlin.com
Link: https://lore.kernel.org/20260908203230.401020-2-atomlin@atomlin.com
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Fixes: be7de5f91fdc ("modules: Add kernel parameter to blacklist modules")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/module/main.c~module-treat-dashes-and-underscores-interchangeably-in-module_blacklist
+++ a/kernel/module/main.c
@@ -2942,7 +2942,7 @@ static bool blacklisted(const char *modu
 
 	for (p = module_blacklist; *p; p += len) {
 		len = strcspn(p, ",");
-		if (strlen(module_name) == len && !memcmp(module_name, p, len))
+		if (strlen(module_name) == len && parameqn(module_name, p, len))
 			return true;
 		if (p[len] == ',')
 			len++;
_

Patches currently in -mm which might be from atomlin@atomlin.com are

hung_task-reset-warning-budget-when-problem-gets-resolved.patch
hung_task-log-summary-line-when-warning-budget-is-exhausted.patch
module-treat-dashes-and-underscores-interchangeably-in-module_blacklist.patch
module-extend-module_blacklist-parameter-to-built-in-modules.patch
module-rename-module_blacklist-to-module_denylist.patch

