Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794780744;
	b=VjMzkc7HhquazTmeyyTfqXjBqqbKGcKxt00d2RQYas5QOcEPbDewPfavouVJHY61pnQO
	 TmZpwZzxIzIXTwVoQWrbVvTm4CoA1LoM5blGu1FXtja8ByasBInc2deLe9ye2oi5jjlGC
	 cmKYf+VqoWTNNuZZryERQjSz5Q5C7AxkAvDrsQmzCRdp4WvvCd9XlU5VXpa8jSZb/4VxW
	 nQwqi4Ypkc2/MbSgd2S/MPGwCBqepTmocJxryGNV/N4gkJCiNihAvd2LFdTyeH1H8YYoY
	 F4h/rCjYaYm6VHpBo7qeL2G0itRzR+sLGsrf5QxbpOIOWNelb6RftFkqPmHnB58ajng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794780744;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Tlz1HD7InWvScfZCqPO83hodDuMu9crozjyFOjIU1xs=;
	b=F7HZUNuH9lhPBw+3OdQ67iVy2CmdLukS8ErGsIaBtTelnoJ8egULvem3xZvVMORbUwo8
	 zcQi38D3JxE+Twp0RW5Yveztu+sLZ04EqSKQjxG11o6aJxFWxHsa3Xzk2fSG/USx4Wf36
	 D8wZGxvcwcFZiBlgV5U6Iet6AYCEIzhnJU4QhpJVMAafyBiQbrtrtt7LeyZp7KLvT52qZ
	 67WiX1uVThYlA0vPwQwXfYvmEe9zdENVb919P3F2Cwibgdt52SnWJ4DaIAkaX0WTk5LWh
	 zrWxm5MBo9HgfGWEQ2ga8n7c8tHdtOtyKD8NBpxSBvaRBaDA+KolZQnRLNYf+WR++Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=b35PkCNE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B3E606A329;
	Sun, 15 Nov 2026 22:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=b35PkCNE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0B61F000C5;
	Sun, 15 Nov 2026 22:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794780744;
	bh=Tlz1HD7InWvScfZCqPO83hodDuMu9crozjyFOjIU1xs=;
	h=Date:To:From:Subject;
	b=b35PkCNEIWLW8z2F0ks7kWUZ5J+64kGplVfjFdt7kb15ZVyP9gsUAbVYgI+FOAXsi
	 MxqU93LVwQHNX26s2v+dx0g0t5SOeQOkqxhkrqjp1EJUdYWR99ZhVurXNZfYFfVqpT
	 8Lw8fLuW/9if/Kx5QFWG70ibeVnZ1TYSnwCi3mi0=
Date: Sun, 15 Nov 2026 14:12:23 -0800
To: mm-commits@vger.kernel.org,vasily.averin@linux.dev,stable@vger.kernel.org,
	shakeel.butt@linux.dev,mkoutny@suse.com,mhocko@suse.com,
	manfred@colorfullife.com,legion@kernel.org,hannes@cmpxchg.org,
	ebiederm@xmission.com,dave@stgolabs.net,alx@kernel.org,
	akpm@linux-foundation.org,x-professor@outlook.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-sem-reject-negative-semopm-values.patch added to mm-nonmm-unstable branch
Message-Id: <20261115221224.0C0B61F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ipc/sem: reject negative SEMOPM values
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-sem-reject-negative-semopm-values.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-sem-reject-negative-semopm-values.patch

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
From: Yingjie Wang <x-professor@outlook.com>
Subject: ipc/sem: reject negative SEMOPM values
Date: Thu, 29 Oct 2026 05:03:26 +0000

A negative SEMOPM becomes a large unsigned limit in semop(), allowing
operation counts that the configured limit should reject.  Separately, a
kernel.sem write can return ERANGE for an invalid SEMMNI while leaving
earlier fields changed; if it leaves SEMOPM at zero, subsequent nonempty
semop() calls in that IPC namespace fail with E2BIG.  Validate the whole
write before changing the live settings.

The SEMOPM field has been stored as an int while semop() receives an
unsigned operation count since the beginning of Git history. A negative
SEMOPM accepted by proc_dointvec() is converted to a large unsigned value
in the comparison, defeating the intended operation-count limit.

Commit 50ec499b9a43 ("sysctl: allow change system v ipc sysctls inside ipc
namespace") made kernel.sem writable by IPC namespace owners without
capabilities in the initial user namespace.

Parse writes against a temporary copy and validate SEMOPM and SEMMNI
before changing the live settings. Hold a per-namespace mutex from the
snapshot through publication so concurrent sysctl writers cannot publish
stale values for fields they did not supply. Access the live fields with
READ_ONCE() and WRITE_ONCE(), preserving the per-field access semantics of
proc_dointvec(). Read requests continue to use proc_dointvec() directly.

Failed writes leave the live settings unchanged. Successful partial writes
change only the supplied fields relative to the latest locked snapshot.
The writer mutex retains the existing per-field visibility for readers.

Keep zero and positive SEMOPM values valid. Zero continues to reject every
non-empty semop() request.

Link: https://lore.kernel.org/16988f0510fc9ebe56c4f337facf92071fb52355.1793250194.git.x-professor@outlook.com
Link: https://lore.kernel.org/r/51c93c19-f1dd-455f-8698-6b1ee30eb630@colorfullife.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yingjie Wang <x-professor@outlook.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Link: https://lore.kernel.org/r/20261016155905.2a659b7bb7d61f33467a3263@linux-foundation.org
Reviewed-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Vasily Averin <vasily.averin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Alejandro Colomar <alx@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: <stable@vger.kernel.org>

 include/linux/ipc_namespace.h |    3 ++
 ipc/ipc_sysctl.c              |   35 +++++++++++++++++++++++---------
 ipc/sem.c                     |    1 
 ipc/util.h                    |    9 --------
 4 files changed, 30 insertions(+), 18 deletions(-)

--- a/include/linux/ipc_namespace.h~ipc-sem-reject-negative-semopm-values
+++ a/include/linux/ipc_namespace.h
@@ -4,6 +4,7 @@
 
 #include <linux/err.h>
 #include <linux/idr.h>
+#include <linux/mutex.h>
 #include <linux/rwsem.h>
 #include <linux/notifier.h>
 #include <linux/nsproxy.h>
@@ -31,6 +32,8 @@ struct ipc_ids {
 struct ipc_namespace {
 	struct ipc_ids	ids[3];
 
+	/* Serialize kernel.sem writers. */
+	struct mutex	sem_ctls_mutex;
 	int		sem_ctls[4];
 	int		used_sems;
 
--- a/ipc/ipc_sysctl.c~ipc-sem-reject-negative-semopm-values
+++ a/ipc/ipc_sysctl.c
@@ -51,21 +51,38 @@ static int proc_ipc_auto_msgmni(const st
 static int proc_ipc_sem_dointvec(const struct ctl_table *table, int write,
 	void *buffer, size_t *lenp, loff_t *ppos)
 {
+	struct ctl_table ipc_table;
 	struct ipc_namespace *ns =
 		container_of(table->data, struct ipc_namespace, sem_ctls);
-	int ret, semmni;
+	int sem_ctls[ARRAY_SIZE(ns->sem_ctls)];
+	size_t i;
+	int ret;
 
-	semmni = ns->sem_ctls[3];
-	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	if (!write)
+		return proc_dointvec(table, write, buffer, lenp, ppos);
 
-	if (!ret)
-		ret = sem_check_semmni(ns);
+	mutex_lock(&ns->sem_ctls_mutex);
+	for (i = 0; i < ARRAY_SIZE(sem_ctls); i++)
+		sem_ctls[i] = READ_ONCE(ns->sem_ctls[i]);
 
-	/*
-	 * Reset the semmni value if an error happens.
-	 */
+	ipc_table = *table;
+	ipc_table.data = sem_ctls;
+
+	ret = proc_dointvec(&ipc_table, write, buffer, lenp, ppos);
 	if (ret)
-		ns->sem_ctls[3] = semmni;
+		goto out_unlock;
+
+	if (sem_ctls[2] < 0 ||
+	    sem_ctls[3] < 0 || sem_ctls[3] > ipc_mni) {
+		ret = -ERANGE;
+		goto out_unlock;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(sem_ctls); i++)
+		WRITE_ONCE(ns->sem_ctls[i], sem_ctls[i]);
+
+out_unlock:
+	mutex_unlock(&ns->sem_ctls_mutex);
 	return ret;
 }
 
--- a/ipc/sem.c~ipc-sem-reject-negative-semopm-values
+++ a/ipc/sem.c
@@ -248,6 +248,7 @@ static int sysvipc_sem_proc_show(struct
 
 void sem_init_ns(struct ipc_namespace *ns)
 {
+	mutex_init(&ns->sem_ctls_mutex);
 	ns->sc_semmsl = SEMMSL;
 	ns->sc_semmns = SEMMNS;
 	ns->sc_semopm = SEMOPM;
--- a/ipc/util.h~ipc-sem-reject-negative-semopm-values
+++ a/ipc/util.h
@@ -246,15 +246,6 @@ int ipcget(struct ipc_namespace *ns, str
 void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
 		void (*free)(struct ipc_namespace *, struct kern_ipc_perm *));
 
-static inline int sem_check_semmni(struct ipc_namespace *ns) {
-	/*
-	 * Check semmni range [0, ipc_mni]
-	 * semmni is the last element of sem_ctls[4] array
-	 */
-	return ((ns->sem_ctls[3] < 0) || (ns->sem_ctls[3] > ipc_mni))
-		? -ERANGE : 0;
-}
-
 #ifdef CONFIG_COMPAT
 #include <linux/compat.h>
 struct compat_ipc_perm {
_

Patches currently in -mm which might be from x-professor@outlook.com are

ipc-sem-account-dynamically-allocated-sops-arrays-to-memcg.patch
ipc-sem-reject-negative-semopm-values.patch
ipc-sem-remove-obsolete-semopm-fragmentation-warning.patch

