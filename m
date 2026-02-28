Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DF4342CA9
	for <mm-commits@vger.kernel.org>; Sat, 28 Feb 2026 19:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772308392; cv=none; b=VUSCU392oG/Y6rc1Mp5Hiy9ztnzJBZDE8lf8qsO3y7KwfLYjeIC2s6RAyD3rFqsX9a9DLq3lEjRUfWms6hbt/TP6/ZwDTqoy8pFsGmywAoJPVMxl2DO3/1J0Zg585FZLefFUFN/5aLKoRVluG6JioNcJJIIynPD7wZB+QEVPEzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772308392; c=relaxed/simple;
	bh=fHJOeraW8EWgJYhYMfFD3Kh5IjAe63qJu4V2p5IckV4=;
	h=Date:To:From:Subject:Message-Id; b=HjIz43/eaLllupkFxS22fNP3y8kGJKEIs1empORBptkwarPyI0ccZVpwYJEYHbBPjMd8kokd05ydSwhJklTU5DUYJHZ+YfLcTIuL66FiRKeYYHlj74VN+YiN4LAte5j+5BnUdbkM71cD6lRf+bhzjdMFWXfz5o02y0Yuu1BpcAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qW00w8F8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qW00w8F8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B77C116D0;
	Sat, 28 Feb 2026 19:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772308392;
	bh=fHJOeraW8EWgJYhYMfFD3Kh5IjAe63qJu4V2p5IckV4=;
	h=Date:To:From:Subject:From;
	b=qW00w8F8YjbYAknK6Vy8B/c79pAIYVUBV0Dp+F7ZCXB4XsSsECIJMKA/twrkf00wQ
	 XFjepN+xp+LokZHqI02niXIcxOPjsSFQnUhAQLEYsLA3+Y31bsCdnElrEMWn3gSTSX
	 jvDZf6KEJC/YRv7DByphteP7n0GgWp++DK5sidcM=
Date: Sat, 28 Feb 2026 11:53:11 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,bhe@redhat.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash_dump-fix-typo-in-function-name-read_key_from_user_keying.patch added to mm-nonmm-unstable branch
Message-Id: <20260228195312.12B77C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash_dump: fix typo in function name read_key_from_user_keying
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash_dump-fix-typo-in-function-name-read_key_from_user_keying.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash_dump-fix-typo-in-function-name-read_key_from_user_keying.patch

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
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: crash_dump: fix typo in function name read_key_from_user_keying
Date: Sat, 28 Feb 2026 00:04:21 +0100

The function read_key_from_user_keying() is missing an 'r' in its name. 
Fix the typo by renaming it to read_key_from_user_keyring().

Link: https://lkml.kernel.org/r/20260227230422.859423-1-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_dump_dm_crypt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/crash_dump_dm_crypt.c~crash_dump-fix-typo-in-function-name-read_key_from_user_keying
+++ a/kernel/crash_dump_dm_crypt.c
@@ -139,7 +139,7 @@ static int restore_dm_crypt_keys_to_thre
 	return 0;
 }
 
-static int read_key_from_user_keying(struct dm_crypt_key *dm_key)
+static int read_key_from_user_keyring(struct dm_crypt_key *dm_key)
 {
 	const struct user_key_payload *ukp;
 	struct key *key;
@@ -387,7 +387,7 @@ static int build_keys_header(void)
 
 		strscpy(keys_header->keys[i].key_desc, key->description,
 			KEY_DESC_MAX_LEN);
-		r = read_key_from_user_keying(&keys_header->keys[i]);
+		r = read_key_from_user_keyring(&keys_header->keys[i]);
 		if (r != 0) {
 			kexec_dprintk("Failed to read key %s\n",
 				      keys_header->keys[i].key_desc);
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

crash_dump-dont-log-dm-crypt-key-bytes-in-read_key_from_user_keying.patch
fork-replace-simple_strtoul-with-kstrtoul-in-coredump_filter_setup.patch
crash_dump-remove-redundant-less-than-zero-check.patch
crash_dump-fix-typo-in-function-name-read_key_from_user_keying.patch

