Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795065819;
	b=i7/cmJmlRxBeo/6oS4LcU0kAXmol4bpoDVbMDrHMoZnAWlupj0Wv5+v/jHzL7i6zbzEO
	 Eyv0B45LU70Nie1zIKc5MZgQcT3CxLWmPtFLyFnWCDNJgE2VipZgKLG3QbHXjU/BDfyeg
	 QwrX0KEruzhxWUL7d9HEx3ISDSL34TOH5UJfr9LT6usWip97OgNx6Pz6LQeTTCGvKfI/0
	 kfsywSstbpxgy50Hm76lv0Z3yaMNhCPFKuRMS+Ci/iVd9R385CjFACzfopeBPd5qH0sLK
	 SYRGBaFkinUfflp91Zv2L15FFQqXU8t0KlMo9mrM3ki7wtLyUo4gydkVW0b3pFU+Vpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795065819;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=Klj8EQvteVIN3N7mlN/lVBqe3+3aTT4l9tBilOBuI/4=;
	b=Rhj43dJRDZrwU0oZhJ/ecid8a0ezZ5LW5/gL8UQMvQw5LeD3ivgXm23ynv+eRWyzQXM/
	 pwfpl6pFfUboine9u1CvXnjXke/bxHcicFnu4q6kbr2DUgZpHbqlNtrDbLU6zPDofYfiT
	 q0pjnvLoUUuWSwqwlu1dTRedNIatuqyYzjr4Y0wxY0ZDUH2uKv2JkcnYdh1D5uxaapSS8
	 BseLTp8Fz8k5NYkcVrKnE1SsaDTI4Nqy+UJRZN7C6nh9mBcMiAK9HOcldViwxDZCnENF7
	 EyizFOMeSL9MvyQgIwM3NSHLXX3IisvQXND32LzorrqJLbMjkK7zcmw3UG6kJzgXqLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wt42hxxW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001FF606A325
	for <mm-commits@vger.kernel.org>; Thu, 19 Nov 2026 05:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wt42hxxW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E8F1F000C4;
	Thu, 19 Nov 2026 05:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795065818;
	bh=Klj8EQvteVIN3N7mlN/lVBqe3+3aTT4l9tBilOBuI/4=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=wt42hxxW004mYapU0PqExpWKxEq6TGsMSKsRj1x49oIY5GR296PYqJJGeMsoeQgqK
	 VhWfdjhfBJr/pbb5czGVAqAgxvwQAZTW42sXfT77WlK24fTAO9YJJEXKG1hPZkH0xr
	 qY83v640fNf8qCHaXU4ZB3sIekAgi78I0yzkINtQ=
Date: Wed, 18 Nov 2026 21:23:38 -0800
To: mm-commits@vger.kernel.org,wfelipe@google.com,ryan.roberts@arm.com,
	rppt@kernel.org,mhiramat@kernel.org,leitao@debian.org,ekffu200098@gmail.com,
	brauner@kernel.org,blum@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261118114034.623145-2-blum@kernel.org>
References: <20261118114034.623145-2-blum@kernel.org>
Subject: + init-use-array_size-in-unknown_bootoption.patch added to mm-nonmm-unstable branch
Message-Id: <20261119052338.92E8F1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: init: Use ARRAY_SIZE() in unknown_bootoption()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-use-array_size-in-unknown_bootoption.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-use-array_size-in-unknown_bootoption.patch

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
From: Thorsten Blum <blum@kernel.org>
Subject: init: Use ARRAY_SIZE() in unknown_bootoption()
Date: Wed, 18 Nov 2026 12:40:32 +0100

Remove the NULL terminator from the bootloader array, make its entries
const, and use ARRAY_SIZE() as the loop bound. Make the array itself
static and mark it __initconst, since it is only used during
initialization.

Also reuse the loop index i instead of redeclaring it multiple times.

Link: https://patch.msgid.link/20261118114034.623145-2-blum@kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Breno Leitao <leitao@debian.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Wilson Felipe Pereira <wfelipe@google.com>

 init/main.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/init/main.c~init-use-array_size-in-unknown_bootoption
+++ a/init/main.c
@@ -577,7 +577,8 @@ static int __init unknown_bootoption(cha
 	 * 1. LILO/Grub pass "BOOT_IMAGE=...";
 	 * 2. kexec/kdump (kexec-tools) pass "kexec".
 	 */
-	const char *bootloader[] = { "BOOT_IMAGE=", "kexec", NULL };
+	static const char * const bootloader[] __initconst = { "BOOT_IMAGE=", "kexec" };
+	unsigned int i;
 
 	/* Handle params aliased to sysctls */
 	if (sysctl_is_alias(param))
@@ -586,7 +587,7 @@ static int __init unknown_bootoption(cha
 	repair_env_string(param, val);
 
 	/* Handle bootloader identifier */
-	for (int i = 0; bootloader[i]; i++) {
+	for (i = 0; i < ARRAY_SIZE(bootloader); i++) {
 		if (strstarts(param, bootloader[i]))
 			return 0;
 	}
@@ -604,7 +605,6 @@ static int __init unknown_bootoption(cha
 
 	if (val) {
 		/* Environment option */
-		unsigned int i;
 		for (i = 0; envp_init[i]; i++) {
 			if (!strncmp(param, envp_init[i], len+1))
 				break;
@@ -616,7 +616,6 @@ static int __init unknown_bootoption(cha
 		envp_init[i] = param;
 	} else {
 		/* Command line option */
-		unsigned int i;
 		for (i = 0; argv_init[i]; i++) {
 			if (i == MAX_INIT_ARGS) {
 				panic_later = "init";
_

Patches currently in -mm which might be from blum@kernel.org are

init-reject-bare-rodata-parameter-before-architecture-parsing.patch
init-use-strscpy-in-do_initcalls.patch
init-use-kmalloc-in-do_initcalls.patch
init-remove-strlcat-and-sprintf-from-do_one_initcall.patch
init-use-strscpy-in-initcall_blacklist.patch
init-combine-blacklist-entry-allocations-in-initcall_blacklist.patch
parport-use-kstrdup-in-parse_data.patch
init-use-array_size-in-unknown_bootoption.patch

