From: akpm@linux-foundation.org
Subject: + keys-dont-call-up_write-if-__key_link_begin-returns-an-error.patch added to -mm tree
Date: Wed, 22 Dec 2010 14:04:28 -0800
Message-ID: <201012222204.oBMM4TH7022025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751593Ab0LVWEl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Dec 2010 17:04:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, jlayton@redhat.com


The patch titled
     keys: don't call up_write() if __key_link_begin() returns an error
has been added to the -mm tree.  Its filename is
     keys-dont-call-up_write-if-__key_link_begin-returns-an-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: keys: don't call up_write() if __key_link_begin() returns an error
From: David Howells <dhowells@redhat.com>

In construct_alloc_key(), up_write() is called in the error path if
__key_link_begin() fails, but this is incorrect as __key_link_begin() only
returns with the nominated keyring locked if it returns successfully.

Without this patch, you might see the following in dmesg:

	=====================================
	[ BUG: bad unlock balance detected! ]
	-------------------------------------
	mount.cifs/5769 is trying to release lock (&key->sem) at:
	[<ffffffff81201159>] request_key_and_link+0x263/0x3fc
	but there are no more locks to release!

	other info that might help us debug this:
	3 locks held by mount.cifs/5769:
	 #0:  (&type->s_umount_key#41/1){+.+.+.}, at: [<ffffffff81131321>] sget+0x278/0x3e7
	 #1:  (&ret_buf->session_mutex){+.+.+.}, at: [<ffffffffa0258e59>] cifs_get_smb_ses+0x35a/0x443 [cifs]
	 #2:  (root_key_user.cons_lock){+.+.+.}, at: [<ffffffff81201000>] request_key_and_link+0x10a/0x3fc

	stack backtrace:
	Pid: 5769, comm: mount.cifs Not tainted 2.6.37-rc6+ #1
	Call Trace:
	 [<ffffffff81201159>] ? request_key_and_link+0x263/0x3fc
	 [<ffffffff81081601>] print_unlock_inbalance_bug+0xca/0xd5
	 [<ffffffff81083248>] lock_release_non_nested+0xc1/0x263
	 [<ffffffff81201159>] ? request_key_and_link+0x263/0x3fc
	 [<ffffffff81201159>] ? request_key_and_link+0x263/0x3fc
	 [<ffffffff81083567>] lock_release+0x17d/0x1a4
	 [<ffffffff81073f45>] up_write+0x23/0x3b
	 [<ffffffff81201159>] request_key_and_link+0x263/0x3fc
	 [<ffffffffa026fe9e>] ? cifs_get_spnego_key+0x61/0x21f [cifs]
	 [<ffffffff812013c5>] request_key+0x41/0x74
	 [<ffffffffa027003d>] cifs_get_spnego_key+0x200/0x21f [cifs]
	 [<ffffffffa026e296>] CIFS_SessSetup+0x55d/0x1273 [cifs]
	 [<ffffffffa02589e1>] cifs_setup_session+0x90/0x1ae [cifs]
	 [<ffffffffa0258e7e>] cifs_get_smb_ses+0x37f/0x443 [cifs]
	 [<ffffffffa025a9e3>] cifs_mount+0x1aa1/0x23f3 [cifs]
	 [<ffffffff8111fd94>] ? alloc_debug_processing+0xdb/0x120
	 [<ffffffffa027002c>] ? cifs_get_spnego_key+0x1ef/0x21f [cifs]
	 [<ffffffffa024cc71>] cifs_do_mount+0x165/0x2b3 [cifs]
	 [<ffffffff81130e72>] vfs_kern_mount+0xaf/0x1dc
	 [<ffffffff81131007>] do_kern_mount+0x4d/0xef
	 [<ffffffff811483b9>] do_mount+0x6f4/0x733
	 [<ffffffff8114861f>] sys_mount+0x88/0xc2
	 [<ffffffff8100ac42>] system_call_fastpath+0x16/0x1b

Reported-by: Jeff Layton <jlayton@redhat.com>
Reviewed-and-Tested-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/keys/request_key.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN security/keys/request_key.c~keys-dont-call-up_write-if-__key_link_begin-returns-an-error security/keys/request_key.c
--- a/security/keys/request_key.c~keys-dont-call-up_write-if-__key_link_begin-returns-an-error
+++ a/security/keys/request_key.c
@@ -403,7 +403,6 @@ link_check_failed:
 	return ret;
 
 link_prealloc_failed:
-	up_write(&dest_keyring->sem);
 	mutex_unlock(&user->cons_lock);
 	kleave(" = %d [prelink]", ret);
 	return ret;
_

Patches currently in -mm which might be from dhowells@redhat.com are

linux-next.patch
keys-dont-call-up_write-if-__key_link_begin-returns-an-error.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages.patch
mm-add-foll_mlock-follow_page-flag.patch
mm-move-vm_locked-check-to-__mlock_vma_pages_range.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
frv-duplicate-output_buffer-of-e03.patch
set_rtc_mmss-show-warning-message-only-once.patch
kernel-clean-up-use_generic_smp_helpers.patch
mm-numa-aware-alloc_task_struct_node.patch
mm-numa-aware-alloc_thread_info_node.patch
kthread-numa-aware-kthread_create_on_cpu.patch
kthread-use-kthread_create_on_cpu.patch
bitops-introduce-little-endian-bitops-for-most-architectures.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

