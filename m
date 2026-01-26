Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2688248B;
	Mon, 26 Jan 2026 19:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769455128; cv=none; b=EOuGYIzBa5GmfQ984+tRBxHv6x5bLWUbCqPU5xZyT3nMeuLQPgw7pNn98Rlppz9641f3rz0eQovmFbpV4FVNaMwr3y7GSfXhIq/sVhexfHg/No2bUWQll6/wwm18K9y3YDX2jzqh8TRYUbXxK/B3EyD7KChClKhw8QesFA8DT2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769455128; c=relaxed/simple;
	bh=Q7peF+PxOketRj3Hl/kQj/BSo4SpIydQAYUDzJuBoAM=;
	h=Date:To:From:Subject:Message-Id; b=CPco7aXWWI//5ctUAvuxQvQBzlZ/LbwRLCMhN0jYUoDEvfS5Y22bcI3q2LCGS64iIoYUmeIla2ZqzrJJCAT3C4ET/R9YOeUORX5yrner8uy1biqYgb6OZ3GGrYc5HRXAe0UCtpVgqT5RCCzaz790wMJ5Ndd/VssDeGXSx7tER3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ez+DEnbm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ez+DEnbm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEFDC116C6;
	Mon, 26 Jan 2026 19:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769455127;
	bh=Q7peF+PxOketRj3Hl/kQj/BSo4SpIydQAYUDzJuBoAM=;
	h=Date:To:From:Subject:From;
	b=Ez+DEnbmbKXMaSnRyQoEKyJkmSfFBvueUECIaWitVpRGgpbFtpNgV2U13g8AYHJIp
	 4IQ6w5uhb61kYa20EgJADeoG3kKrHbpE1qL6ah4goUp5GknyPhLNwK+bu6i19FYtSh
	 +UvU4B0UuF9Liv/4jnaaMTpKHlZ3Iz4yMDmj6Dy4=
Date: Mon, 26 Jan 2026 11:18:46 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,stable@vger.kernel.org,dyoung@redhat.com,coxu@redhat.com,bhe@redhat.com,gor@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash_dump-fix-dm_crypt-keys-locking-and-ref-leak.patch added to mm-nonmm-unstable branch
Message-Id: <20260126191847.6CEFDC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash_dump: fix dm_crypt keys locking and ref leak
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash_dump-fix-dm_crypt-keys-locking-and-ref-leak.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash_dump-fix-dm_crypt-keys-locking-and-ref-leak.patch

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

crash_dump-fix-dm_crypt-keys-locking-and-ref-leak.patch

