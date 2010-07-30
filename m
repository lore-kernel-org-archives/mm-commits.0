From: akpm@linux-foundation.org
Subject: + cifs-remove-__exit-mark-from-cifs_exit_dns_resolver.patch added to -mm tree
Date: Fri, 30 Jul 2010 16:08:27 -0700
Message-ID: <201007302308.o6UN8Ra8006446@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752065Ab0G3XJH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jul 2010 19:09:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, jlayton@redhat.com, sfrench@us.ibm.com


The patch titled
     cifs: remove __exit mark from cifs_exit_dns_resolver()
has been added to the -mm tree.  Its filename is
     cifs-remove-__exit-mark-from-cifs_exit_dns_resolver.patch

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
Subject: cifs: remove __exit mark from cifs_exit_dns_resolver()
From: David Howells <dhowells@redhat.com>

Remove the __exit mark from cifs_exit_dns_resolver() as it's called by the
module init routine in case of error, and so may have been discarded
during linkage.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/dns_resolve.c |    2 +-
 fs/cifs/dns_resolve.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/cifs/dns_resolve.c~cifs-remove-__exit-mark-from-cifs_exit_dns_resolver fs/cifs/dns_resolve.c
--- a/fs/cifs/dns_resolve.c~cifs-remove-__exit-mark-from-cifs_exit_dns_resolver
+++ a/fs/cifs/dns_resolve.c
@@ -228,7 +228,7 @@ failed_put_cred:
 	return ret;
 }
 
-void __exit cifs_exit_dns_resolver(void)
+void cifs_exit_dns_resolver(void)
 {
 	key_revoke(dns_resolver_cache->thread_keyring);
 	unregister_key_type(&key_type_dns_resolver);
diff -puN fs/cifs/dns_resolve.h~cifs-remove-__exit-mark-from-cifs_exit_dns_resolver fs/cifs/dns_resolve.h
--- a/fs/cifs/dns_resolve.h~cifs-remove-__exit-mark-from-cifs_exit_dns_resolver
+++ a/fs/cifs/dns_resolve.h
@@ -25,7 +25,7 @@
 
 #ifdef __KERNEL__
 extern int __init cifs_init_dns_resolver(void);
-extern void __exit cifs_exit_dns_resolver(void);
+extern void cifs_exit_dns_resolver(void);
 extern int dns_resolve_server_name_to_ip(const char *unc, char **ip_addr);
 #endif /* KERNEL */
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
cifs-remove-__exit-mark-from-cifs_exit_dns_resolver.patch
linux-next.patch
kmap_atomic-make-kunmap_atomic-harder-to-misuse.patch
frv-duplicate-output_buffer-of-e03.patch
rwsem-fully-separate-code-pathes-to-wake-writers-vs-readers.patch
rwsem-lighter-active-count-checks-when-waking-up-readers.patch
rwsem-let-rwsem_waiting_bias-represent-any-number-of-waiting-threads.patch
rwsem-wake-queued-readers-when-writer-blocks-on-active-read-lock.patch
rwsem-smaller-wrappers-around-rwsem_down_failed_common.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

