Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794802285;
	b=19+yJAGNez+xoM275hMLt3Z/N3u3zYFZJ73ll1S6SZ1lvLuPMAJny3Jdca7Pkls6O9sT
	 jWgNbRDgZKUovGx0llmSIaSknpL8strbyMbwFXSCx+ncBvjypBCXioko65aX20csgGuLh
	 PvBDYnJK9TP4WW1HHlLP0R2YBWW82i27oclElaV3ULIDUnC8VtLDqLfRL6AesAvPO1qxe
	 1A81zdOyZPzM8BkZUUiZ1r9yWoObH9rKNNCage3wKTcSg+q2DixAlYPvBmJpHMqS2Q/7p
	 Em0HTyHRYt04de85XziuylKATIXb4BnjyouwRfsDDTS5O+10gYemn0szmQ7YCfTAxog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794802285;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=gz4z6LxM3HAOvOPy/opl82HQTiyfglp+Koojt6BabMA=;
	b=tRHp7ns91mxGTeizMlXZUCC92pGNiqR8FpN4qMqjjFr4BbDyQxa/YQWRyXvz/fyMqUxV
	 Dtz84muV30yeZdMeN88IO+KaLATMG8AJQF6EU6aSjdZdUCf2K99N3n3ZBUVnfEa41cM1S
	 L2kCOR5aJ3rVK5n3lA6XMHO0DTWXkmRx9UejxjfaFS7vl8OobLyO/1EFBZvFBA0omyYD1
	 Om3N0q2RuJKxBsQIcuxFBUJbhtP1VxUb+CSMC+tY9b4JgmfsS07brQkDsbA0mL07kjGWn
	 F4sQ2i0jpg9+h9gAE37aeo0q/LEnNsPWtgHdYFTL5p6rQZg9VWDWOV5IarVZV6sPULw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=L2kuAKOP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389B8606A329
	for <mm-commits@vger.kernel.org>; Mon, 16 Nov 2026 04:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=L2kuAKOP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22BB1F000C4;
	Mon, 16 Nov 2026 04:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794802284;
	bh=gz4z6LxM3HAOvOPy/opl82HQTiyfglp+Koojt6BabMA=;
	h=Date:To:From:Subject;
	b=L2kuAKOPeFCzzZHubQ52Ekw5dZaB0I8LZPY5yVACiDR5mD2s52uVi5auzo4cWpmPA
	 tnxtJ1G66VkQD++lojFEh9nkxNdjkzOySQqltFksNVHB9SPVL/wJinCnLP3l4wQ0Hu
	 2NgsYDJ9jyItDbFcqYbJNbRXjk3peI1uguhEOFUo=
Date: Sun, 15 Nov 2026 20:11:24 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,
	rdunlap@infradead.org,osandov@osandov.com,kees@kernel.org,corbet@lwn.net,
	chris@chrisdown.name,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-kcore-allow-disabling-proc-kcore-at-boot.patch added to mm-nonmm-unstable branch
Message-Id: <20261116041124.A22BB1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: proc/kcore: allow disabling /proc/kcore at boot
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-kcore-allow-disabling-proc-kcore-at-boot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-kcore-allow-disabling-proc-kcore-at-boot.patch

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
From: Chris Down <chris@chrisdown.name>
Subject: proc/kcore: allow disabling /proc/kcore at boot
Date: Sun, 15 Nov 2026 19:57:48 -0800

/proc/kcore lets any process with CAP_SYS_RAWIO read all of kernel memory.
That's a pretty large read primitive for anyone who obtains CAP_SYS_RAWIO
(and it also gives away the KASLR layout).

For this reason on some hosts we want to turn /proc/kcore off.  In terms
of what it can read, /proc/kcore isn't any more concerning than other ways
to read kernel memory, like BPF with CAP_BPF and CAP_PERFMON.  The
distinction is that a process with CAP_SYS_RAWIO doesn't necessarily have
CAP_BPF and CAP_PERFMON, because CAP_SYS_RAWIO may be needed for hardware
access without necessarily wanting to grant general RAM access. 
CONFIG_STRICT_DEVMEM already makes that possible for /dev/mem, but
/proc/kcore gives the same capability to do general purpose RAM reading
anyway.

However, on a kernel built with CONFIG_PROC_KCORE=y the only ways to block
it today are lockdown=confidentiality (which also disables many other
things we perhaps don't want to disable, like kprobes and
bpf_probe_read_kernel()), or an LSM.  That's annoying, because on the
majority of hosts we do want it on for things like drgn/crash, so today we
build two separate kernels.

Let's add a "kcore=" boot parameter so that this can be disabled at boot,
which lets us preserve those choices while using the same kernel image.

Link: https://lore.kernel.org/a8474f0e2d0ef5ea9d53aa6649c7e9c9ea6f15c2.1794800574.git.chris@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Omar Sandoval <osandov@osandov.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Kees Cook <kees@kernel.org>

 Documentation/admin-guide/kernel-parameters.txt |    6 ++++++
 fs/proc/kcore.c                                 |   12 ++++++++++++
 2 files changed, 18 insertions(+)

--- a/Documentation/admin-guide/kernel-parameters.txt~proc-kcore-allow-disabling-proc-kcore-at-boot
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -2916,6 +2916,12 @@ Kernel parameters
 			parameter KASAN will print report only for the first
 			invalid access.
 
+	kcore=		[KNL,EARLY]
+			Enable or disable /proc/kcore on kernels built with
+			CONFIG_PROC_KCORE=y.
+			Format: <bool>
+			Default: on
+
 	keep_bootcon	[KNL,EARLY]
 			Do not unregister boot console at start. This is only
 			useful for debugging when something happens in the window
--- a/fs/proc/kcore.c~proc-kcore-allow-disabling-proc-kcore-at-boot
+++ a/fs/proc/kcore.c
@@ -69,6 +69,7 @@ static size_t kcore_notes_len;
 static size_t kcore_data_offset;
 DEFINE_STATIC_PERCPU_RWSEM(kclist_lock);
 static int kcore_need_update = 1;
+static bool kcore_enabled __initdata = true;
 
 /*
  * Returns > 0 for RAM pages, 0 for non-RAM pages, < 0 on error
@@ -722,8 +723,19 @@ static void __init add_modules_range(voi
 }
 #endif
 
+static int __init parse_kcore(char *str)
+{
+	return kstrtobool(str, &kcore_enabled);
+}
+early_param("kcore", parse_kcore);
+
 static int __init proc_kcore_init(void)
 {
+	if (!kcore_enabled) {
+		pr_info("/proc/kcore disabled on command line\n");
+		return 0;
+	}
+
 	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL, &kcore_proc_ops);
 	if (!proc_root_kcore) {
 		pr_err("couldn't create /proc/kcore\n");
_

Patches currently in -mm which might be from chris@chrisdown.name are

mm-memcontrol-dont-lose-track-of-exiting-oom-victims.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test.patch
proc-kcore-allow-disabling-proc-kcore-at-boot.patch

