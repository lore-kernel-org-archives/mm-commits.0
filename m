Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDD22D1913
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671894; cv=none; b=j73qUIs0SRspMVqpkl8stzFWyjaGU6Y8qABHiez7eeftoyM6XYF6ybVLxPI5kQVhD44VfXj+jszEATnNUUQypjmN7cCoSJxqrKy+jR7dwrXIb7PRUrabI7ktes3xi47cpx14M3Uu7gdeuN9aELoiB7b8Q2qW6wxqf+ETJ8WcLFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671894; c=relaxed/simple;
	bh=JaSq2xNmIuWqBPjYhm04uRjEESH26YJrby8oqoytQEo=;
	h=Date:To:From:Subject:Message-Id; b=UdvG40u7CgbSZl7uJZoQiwfxd801YrWAm49hU/O1KZO+3MNh7kIf6fvYtzfDQ7XNsW+zE/f5MvjNsCd6ETAdrhZMajDtQqnhxMi43tEBsfOScUWGh5IONHCfB3mNvmBFAUxqXKzj72YQYSlCRpoH8SAfhI/y7UDKEpJ86kkh1zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uaNg3moi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uaNg3moi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F2FC4CEF7;
	Sat, 28 Mar 2026 04:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671894;
	bh=JaSq2xNmIuWqBPjYhm04uRjEESH26YJrby8oqoytQEo=;
	h=Date:To:From:Subject:From;
	b=uaNg3moiVvc3KpSkNWR6LEtP6qNM/raF3UJesIulvkZIwAHAL7HTO5701yhizWX2Z
	 qtiWW5exRd17Wrp/PPRB5TAQ/hnEygyx7Jd5onOVOCNSy3AsmdJKxqrB2etLpM6qXn
	 Rg/VZeqc1yPXTTQa4Z6QowLN4/3tDe7siZ07oarE=
Date: Fri, 27 Mar 2026 21:24:54 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,bhe@redhat.com,akpm@linux-foundation.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] crash_dump-fix-typo-in-function-name-read_key_from_user_keying.patch removed from -mm tree
Message-Id: <20260328042454.84F2FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash_dump: fix typo in function name read_key_from_user_keying
has been removed from the -mm tree.  Its filename was
     crash_dump-fix-typo-in-function-name-read_key_from_user_keying.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: crash_dump: fix typo in function name read_key_from_user_keying
Date: Sat, 28 Feb 2026 00:04:21 +0100

The function read_key_from_user_keying() is missing an 'r' in its name. 
Fix the typo by renaming it to read_key_from_user_keyring().

Link: https://lkml.kernel.org/r/20260227230422.859423-1-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Baoquan He <bhe@redhat.com>
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


