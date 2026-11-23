Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795475873;
	b=xzN+avxYMwfJ1GXJfBAMR3p9o/ZmAopAEZn1VChfYSlKB3k5HTzCmwP9PYZXpZNxGXTR
	 m9w7KgzyATeBp1VZW4P88d7FTjZU9c3JBEubmgEGVZ7kBNTrvTHhKoKksL44R4oXqtP5H
	 0b5rbYi7U/aqIagalB0m8IqJqbI/PcdWM/sTzKMej/ofyDLl7Y/H4KDKrovK8pbBweQVM
	 nDA4p+pSbL+K01xyl5u1u2ZYZnoGZF/tCDdKgxiGuWp9gNmsgifskzn9xWG1ryBiPh17Y
	 XotEwmFUExWWwFFUSZQXf0C0zTp2PEVcihuAq/Vy9gJCjyDuyl3jP7LbZHrsUGmNXNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795475873;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=gucwOaWLuWZH39Nvq1XClGrmkfr5S32AKAPD44XorQ4=;
	b=Ip8kfUJdpTSu9afk2sIwKP8LDj3yAMlF+VUdIa/Bsf0gC9NQEeP/0aayuG1RmAhzArDI
	 RWaVO1heyma2jH+dlQwDYp5JNb/25L7ePnWeQuX7ctrQzxXySN+0GJW3vVv3rxXso3cGh
	 ofzc3ozVrNWA5Awp9mPQzJC3LpUj18oFVmGk8CHUlB7Fz9Ck8AKCmwT0Q8ykWuIjguxL6
	 vuBzVhWfy3ceRrtHTX3ULJWyPgOpxDq/Bb+hyB3IQZIgR12tYN3yD5noOigc2Sn3wOjFx
	 nAj3g03BtBbnyb7qwASosuxsCQoQ01CnA9stc2E6CELbIJC6M/56NNW1W0kyCr/5/YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vz3Qpz4q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CEE606A31E
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 23:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vz3Qpz4q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CF91F000D1;
	Mon, 23 Nov 2026 23:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795475872;
	bh=gucwOaWLuWZH39Nvq1XClGrmkfr5S32AKAPD44XorQ4=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=vz3Qpz4q0AVc64c9hw+K7Upm88RMlqEpDFXaXTHuqDHXJwOMJaroDpQWHJroewhCQ
	 OZFjfiq8pWj3G30tmT0buwZQ15cIXDwScpD6PbshZIaK1DtLcSNHTQLSdebUcJF88d
	 cDE6pMZwgRB5Z7uiI0Ffo012xW1uLcoGA/oayU9I=
Date: Mon, 23 Nov 2026 15:17:51 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,
	hao.ge@linux.dev,ardb@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261119170353.1835737-2-ardb+git@google.com>
References: <20261119170353.1835737-2-ardb+git@google.com>
Subject: + alloc_tag-use-__-prefixed-elf-section-names.patch added to mm-new branch
Message-Id: <20261123231752.70CF91F000D1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: alloc_tag: use __ prefixed ELF section names
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-use-__-prefixed-elf-section-names.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-use-__-prefixed-elf-section-names.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Ard Biesheuvel <ardb@kernel.org>
Subject: alloc_tag: use __ prefixed ELF section names
Date: Thu, 19 Nov 2026 18:03:54 +0100

The compiler will emit static relocations related to a section .foo into a
separate section called .rela.foo, i.e., it just appends the section name
to the string ".rela"

When section names start with .  or __, this results in section names that
are correctly matched by the various pattern rules in the various linker
scripts across the tree.

Without any such leading delimiter, it may lead to spurious warnings
such as

  >> ld: warning: orphan section `.relaalloc_tags' from `init/main.o' being placed in section `.rela.dyn'
     ld: warning: dot moved backwards before `.rela.dyn'
     ld: .tmp_vmlinux1: section `.rela.dyn' can't be allocated in segment 1

Fix this by renaming the section to __alloc_tags.  While at it, tweak the
headers so that the definition appears only a single time.

Link: https://patch.msgid.link/20261119170353.1835737-2-ardb%2Bgit@google.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Hao Ge <hao.ge@linux.dev>

 include/asm-generic/codetag.lds.h |   14 +++++++++-----
 include/linux/alloc_tag.h         |   11 ++++++-----
 mm/alloc_tag.c                    |    6 +++---
 3 files changed, 18 insertions(+), 13 deletions(-)

--- a/include/asm-generic/codetag.lds.h~alloc_tag-use-__-prefixed-elf-section-names
+++ a/include/asm-generic/codetag.lds.h
@@ -2,6 +2,10 @@
 #ifndef __ASM_GENERIC_CODETAG_LDS_H
 #define __ASM_GENERIC_CODETAG_LDS_H
 
+#include <linux/compiler_types.h>
+
+#define ALLOC_TAG_SECTION_NAME	__alloc_tags
+
 #ifdef CONFIG_MEM_ALLOC_PROFILING
 #define IF_MEM_ALLOC_PROFILING(...) __VA_ARGS__
 #else
@@ -10,15 +14,15 @@
 
 #define SECTION_WITH_BOUNDARIES(_name)	\
 	. = ALIGN(8);			\
-	__start_##_name = .;		\
+	__PASTE(__start_, _name) = .;	\
 	KEEP(*(_name))			\
-	__stop_##_name = .;
+	__PASTE(__stop_, _name) = .;
 
 #define CODETAG_SECTIONS()		\
-	IF_MEM_ALLOC_PROFILING(SECTION_WITH_BOUNDARIES(alloc_tags))
+	IF_MEM_ALLOC_PROFILING(SECTION_WITH_BOUNDARIES(ALLOC_TAG_SECTION_NAME))
 
 #define MOD_SEPARATE_CODETAG_SECTION(_name)	\
-	.codetag.##_name 0 : {			\
+	.codetag._name 0 : {			\
 		SECTION_WITH_BOUNDARIES(_name)	\
 	}
 
@@ -28,6 +32,6 @@
  * unload them individually once unused.
  */
 #define MOD_SEPARATE_CODETAG_SECTIONS()		\
-	IF_MEM_ALLOC_PROFILING(MOD_SEPARATE_CODETAG_SECTION(alloc_tags))
+	IF_MEM_ALLOC_PROFILING(MOD_SEPARATE_CODETAG_SECTION(ALLOC_TAG_SECTION_NAME))
 
 #endif /* __ASM_GENERIC_CODETAG_LDS_H */
--- a/include/linux/alloc_tag.h~alloc_tag-use-__-prefixed-elf-section-names
+++ a/include/linux/alloc_tag.h
@@ -15,6 +15,9 @@
 #include <linux/static_key.h>
 #include <linux/irqflags.h>
 
+/* for ALLOC_TAG_SECTION_NAME */
+#include <asm-generic/codetag.lds.h>
+
 struct alloc_tag_counters {
 	u64 bytes;
 	u64 calls;
@@ -74,8 +77,6 @@ static inline void set_codetag_empty(uni
 
 #ifdef CONFIG_MEM_ALLOC_PROFILING
 
-#define ALLOC_TAG_SECTION_NAME	"alloc_tags"
-
 struct codetag_bytes {
 	struct codetag *ct;
 	s64 bytes;
@@ -98,7 +99,7 @@ DECLARE_PER_CPU(struct alloc_tag_counter
 
 #define DEFINE_ALLOC_TAG(_alloc_tag)						\
 	static struct alloc_tag _alloc_tag __used __aligned(8)			\
-	__section(ALLOC_TAG_SECTION_NAME) = {					\
+	__section(__stringify(ALLOC_TAG_SECTION_NAME)) = {			\
 		.ct = CODE_TAG_INIT,						\
 		.counters = &_shared_alloc_tag };
 
@@ -108,7 +109,7 @@ DECLARE_PER_CPU(struct alloc_tag_counter
 
 #define DEFINE_ALLOC_TAG(_alloc_tag)						\
 	static struct alloc_tag _alloc_tag __used __aligned(8)			\
-	__section(ALLOC_TAG_SECTION_NAME) = {					\
+	__section(__stringify(ALLOC_TAG_SECTION_NAME)) = {			\
 		.ct = CODE_TAG_INIT,						\
 		.counters = NULL };
 
@@ -117,7 +118,7 @@ DECLARE_PER_CPU(struct alloc_tag_counter
 #define DEFINE_ALLOC_TAG(_alloc_tag)						\
 	static DEFINE_PER_CPU(struct alloc_tag_counters, _alloc_tag_cntr);	\
 	static struct alloc_tag _alloc_tag __used __aligned(8)			\
-	__section(ALLOC_TAG_SECTION_NAME) = {					\
+	__section(__stringify(ALLOC_TAG_SECTION_NAME)) = {			\
 		.ct = CODE_TAG_INIT,						\
 		.counters = &_alloc_tag_cntr };
 
--- a/mm/alloc_tag.c~alloc_tag-use-__-prefixed-elf-section-names
+++ a/mm/alloc_tag.c
@@ -26,8 +26,8 @@
 
 #define ALLOCINFO_FILE_NAME		"allocinfo"
 #define MODULE_ALLOC_TAG_VMAP_SIZE	(100000UL * sizeof(struct alloc_tag))
-#define SECTION_START(NAME)		(CODETAG_SECTION_START_PREFIX NAME)
-#define SECTION_STOP(NAME)		(CODETAG_SECTION_STOP_PREFIX NAME)
+#define SECTION_START(NAME)		(CODETAG_SECTION_START_PREFIX __stringify(NAME))
+#define SECTION_STOP(NAME)		(CODETAG_SECTION_STOP_PREFIX __stringify(NAME))
 
 #ifdef CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT
 static bool mem_profiling_support = true;
@@ -1466,7 +1466,7 @@ static inline void sysctl_init(void) {}
 static int __init alloc_tag_init(void)
 {
 	const struct codetag_type_desc desc = {
-		.section		= ALLOC_TAG_SECTION_NAME,
+		.section		= __stringify(ALLOC_TAG_SECTION_NAME),
 		.tag_size		= sizeof(struct alloc_tag),
 #ifdef CONFIG_MODULES
 		.needs_section_mem	= needs_section_mem,
_

Patches currently in -mm which might be from ardb@kernel.org are

alloc_tag-use-__-prefixed-elf-section-names.patch

