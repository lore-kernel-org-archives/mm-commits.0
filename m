Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580173EBF1D;
	Sun,  1 Feb 2026 00:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905028; cv=none; b=b0I1grfEmVt0IrteNSX0i7YeCz/Qa0rSnMFmiSNL7VySlF5zDvX2on5za32GuZOdmD904OKRwFkIlXjrTL9iMFA4PdtKfifv3OmQ02oNTMbXtsJYbrIMq9UfYUsOk55nJ4mCJBAXFVHdLmskxcALlqB3gfgZlwzR+NVY1EdbICw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905028; c=relaxed/simple;
	bh=iV4zz0DlYN7DO4SK5Ru0QB+k2B4ytTaTPfO0gtSncIc=;
	h=Date:To:From:Subject:Message-Id; b=gx6XZPY6mBt96eOiDywFyBmSMJTtndcQSVkf5GsoXPQBaSkMRIg8/6VltAK/7fPkhdZy2IP2like/KvQnil0uQxhKPUpKvANGQBqhHe9cj1kpdc93erBGT83F10nPk72E2404K/zGcv74B/RzHzLLkYd4+rYaBtDdeKeMaSGH+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NfvtW1jw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NfvtW1jw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26792C4CEF1;
	Sun,  1 Feb 2026 00:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905028;
	bh=iV4zz0DlYN7DO4SK5Ru0QB+k2B4ytTaTPfO0gtSncIc=;
	h=Date:To:From:Subject:From;
	b=NfvtW1jw8bS18ebDYAhCPxVfTz6JPIspwSy4GFcmSeNdb1kqBN1Sj6rV4YYIunRVM
	 CXRatct+F0smwODYJlhkAqfYrDIKRTaLbMLLvPlgEjvj5Xzp2VLGw3frOT4O8Nxwev
	 ii3L0yuiifnrXJOtXH2xIjFE+3WwHrCjbZXlVoyc=
Date: Sat, 31 Jan 2026 16:17:07 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,stable@vger.kernel.org,dyoung@redhat.com,coxu@redhat.com,bhe@redhat.com,gor@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] crash_dump-fix-dm_crypt-keys-locking-and-ref-leak.patch removed from -mm tree
Message-Id: <20260201001708.26792C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash_dump: fix dm_crypt keys locking and ref leak
has been removed from the -mm tree.  Its filename was
     crash_dump-fix-dm_crypt-keys-locking-and-ref-leak.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vasily Gorbik <gor@linux.ibm.com>
Subject: crash_dump: fix dm_crypt keys locking and ref leak
Date: Mon, 26 Jan 2026 12:20:46 +0100

crash_load_dm_crypt_keys() reads dm-crypt volume keys from the user
keyring.  It uses user_key_payload_locked() without holding key->sem,
which makes lockdep complain when kexec_file_load() assembles the crash
image:

  =============================
  WARNING: suspicious RCU usage
  -----------------------------
  ./include/keys/user-type.h:53 suspicious rcu_dereference_protected() usage!

  other info that might help us debug this:

  rcu_scheduler_active = 2, debug_locks = 1
  no locks held by kexec/4875.

  stack backtrace:
  Call Trace:
   <TASK>
   dump_stack_lvl+0x5d/0x80
   lockdep_rcu_suspicious.cold+0x4e/0x96
   crash_load_dm_crypt_keys+0x314/0x390
   bzImage64_load+0x116/0x9a0
   ? __lock_acquire+0x464/0x1ba0
   __do_sys_kexec_file_load+0x26a/0x4f0
   do_syscall_64+0xbd/0x430
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

In addition, the key returned by request_key() is never key_put()'d,
leaking a key reference on each load attempt.

Take key->sem while copying the payload and drop the key reference
afterwards.

Link: https://lkml.kernel.org/r/patch.git-2d4d76083a5c.your-ad-here.call-01769426386-ext-2560@work.hours
Fixes: 479e58549b0f ("crash_dump: store dm crypt keys in kdump reserved memory")
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_dump_dm_crypt.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/kernel/crash_dump_dm_crypt.c~crash_dump-fix-dm_crypt-keys-locking-and-ref-leak
+++ a/kernel/crash_dump_dm_crypt.c
@@ -143,6 +143,7 @@ static int read_key_from_user_keying(str
 {
 	const struct user_key_payload *ukp;
 	struct key *key;
+	int ret = 0;
 
 	kexec_dprintk("Requesting logon key %s", dm_key->key_desc);
 	key = request_key(&key_type_logon, dm_key->key_desc, NULL);
@@ -152,20 +153,28 @@ static int read_key_from_user_keying(str
 		return PTR_ERR(key);
 	}
 
+	down_read(&key->sem);
 	ukp = user_key_payload_locked(key);
-	if (!ukp)
-		return -EKEYREVOKED;
+	if (!ukp) {
+		ret = -EKEYREVOKED;
+		goto out;
+	}
 
 	if (ukp->datalen > KEY_SIZE_MAX) {
 		pr_err("Key size %u exceeds maximum (%u)\n", ukp->datalen, KEY_SIZE_MAX);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	memcpy(dm_key->data, ukp->data, ukp->datalen);
 	dm_key->key_size = ukp->datalen;
 	kexec_dprintk("Get dm crypt key (size=%u) %s: %8ph\n", dm_key->key_size,
 		      dm_key->key_desc, dm_key->data);
-	return 0;
+
+out:
+	up_read(&key->sem);
+	key_put(key);
+	return ret;
 }
 
 struct config_key {
_

Patches currently in -mm which might be from gor@linux.ibm.com are


