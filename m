Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858002C08BC
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 18:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765995482; cv=none; b=NSoLYlKP0w0DRUlaqmKPU9yfymhN+qxjA1bSsZLu0AyQ7Tc0QJDqliMhRxSp0hYBN0FvAZpYp+y1uN1qwSHorqjOsjEvzLG7B63YUFkXLD6MEbbpWAmKCYyNIscQSdBFPXUKW5GAuaZ9oXtSZtJa6rE+SUXYrwFXjkGMXZ+QfEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765995482; c=relaxed/simple;
	bh=pd6muvyvygsKhTZPf6HKD9dqJTEZrfr5jOlkRlKkjgk=;
	h=Date:To:From:Subject:Message-Id; b=ivVKVaH6tXctUDtBIUxerv2IPdpC1r8Rdq/Lzd/hZEVaLfLr1JHX/egpgGInw/jrfBe14qO2psyiApyO86JsB2wUiESFckjM2hXgGYuDSVsYHrIOKjtEGCK6WVBhMz0vf4OVJQQjzpsdcKG31fp0yVYa2KJS9/tQTALssv9ilMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=faX4fLff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="faX4fLff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB34EC4CEF5;
	Wed, 17 Dec 2025 18:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765995481;
	bh=pd6muvyvygsKhTZPf6HKD9dqJTEZrfr5jOlkRlKkjgk=;
	h=Date:To:From:Subject:From;
	b=faX4fLffo8iqSdQMDjf2QMYjFyyUCzrjJ6QZO4hYbu+uoDoWtJDb/AO3Okv7N1EsA
	 9yZa3c2wms9UrlWNrW2ykro44XRbr2DKYkRSAPfe0TfDU6cWZhwhrkpRUxBXI4HJ34
	 CiDtDRUXdiXGrCmyIUlckhsw1xhbAfwkxvaAyFlo=
Date: Wed, 17 Dec 2025 10:18:01 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-replace-simple_strtoul-with-kstrtobool-in-set_hashdist.patch added to mm-new branch
Message-Id: <20251217181801.CB34EC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init: replace simple_strtoul with kstrtobool in set_hashdist
has been added to the -mm mm-new branch.  Its filename is
     mm-mm_init-replace-simple_strtoul-with-kstrtobool-in-set_hashdist.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-replace-simple_strtoul-with-kstrtobool-in-set_hashdist.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: mm/mm_init: replace simple_strtoul with kstrtobool in set_hashdist
Date: Wed, 17 Dec 2025 12:02:13 +0100

Use bool for 'hashdist' and replace simple_strtoul() with kstrtobool() for
parsing the 'hashdist=' boot parameter.  Unlike simple_strtoul(), which
returns an unsigned long, kstrtobool() converts the string directly to
bool and avoids implicit casting.

Check the return value of kstrtobool() and reject invalid values.  This
adds error handling while preserving behavior for existing values, and
removes use of the deprecated simple_strtoul() helper.  The current code
silently sets 'hashdist = 0' if parsing fails, instead of leaving the
default value (HASHDIST_DEFAULT) unchanged.

Additionally, kstrtobool() accepts common boolean strings such as "on" and
"off".

Link: https://lkml.kernel.org/r/20251217110214.50807-1-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    4 ++--
 mm/mm_init.c             |    9 +++------
 2 files changed, 5 insertions(+), 8 deletions(-)

--- a/include/linux/memblock.h~mm-mm_init-replace-simple_strtoul-with-kstrtobool-in-set_hashdist
+++ a/include/linux/memblock.h
@@ -598,9 +598,9 @@ extern void *alloc_large_system_hash(con
  */
 #ifdef CONFIG_NUMA
 #define HASHDIST_DEFAULT IS_ENABLED(CONFIG_64BIT)
-extern int hashdist;		/* Distribute hashes across NUMA nodes? */
+extern bool hashdist;		/* Distribute hashes across NUMA nodes? */
 #else
-#define hashdist (0)
+#define hashdist (false)
 #endif
 
 #ifdef CONFIG_MEMTEST
--- a/mm/mm_init.c~mm-mm_init-replace-simple_strtoul-with-kstrtobool-in-set_hashdist
+++ a/mm/mm_init.c
@@ -646,21 +646,18 @@ int __meminit early_pfn_to_nid(unsigned
 	return nid;
 }
 
-int hashdist = HASHDIST_DEFAULT;
+bool hashdist = HASHDIST_DEFAULT;
 
 static int __init set_hashdist(char *str)
 {
-	if (!str)
-		return 0;
-	hashdist = simple_strtoul(str, &str, 0);
-	return 1;
+	return kstrtobool(str, &hashdist) == 0;
 }
 __setup("hashdist=", set_hashdist);
 
 static inline void fixup_hashdist(void)
 {
 	if (num_node_state(N_MEMORY) == 1)
-		hashdist = 0;
+		hashdist = false;
 }
 #else
 static inline void fixup_hashdist(void) {}
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

mm-mm_init-replace-simple_strtoul-with-kstrtobool-in-set_hashdist.patch

