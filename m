Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B840331ED92
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282382; cv=none; b=BMNRn62TCQR+A8Xm1Y1Zuofphda67VNMHQ8wcHRF9yF9yEaNbxtZDAdO6u0svnv23HT6q1rT/w4mY0LvbK+m0J5s7C5ixzohEOV0IRDnbmzh45k6YrqEqlUTLPMGN8cR5wYd6wTvpcMuMaN0dG8EyZbKXe9sIlY8rdCQFa/95/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282382; c=relaxed/simple;
	bh=Eb5b3A767kg4i67eCWnq18g9pwRv9oQA2IXUhLEAaME=;
	h=Date:To:From:Subject:Message-Id; b=iv3JE/WorlSjzvvn2DBphUQEOTdO+rZUTO7NmJSIYhFIrNXatlRTugdHrH1qnYWfh+GR6iUYOVKXk8wcqFj/ciy/wLMJhlmQZgvacKwlP3blFJ21t7kenvWc+MblAGvxhEr10ziUHfgW0x893aKGRsXvVEw1av2Tqra3J60W088=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZPJMUObI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZPJMUObI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C130C4CEF8;
	Thu, 27 Nov 2025 22:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282382;
	bh=Eb5b3A767kg4i67eCWnq18g9pwRv9oQA2IXUhLEAaME=;
	h=Date:To:From:Subject:From;
	b=ZPJMUObItT5vncF/fkxKo9ZwWWn/s2fXzQH+d00XG/hfSXbBvLJiPqAe4cGls34Hc
	 riFiKtUITjFf1emErB/87vdfBCCoyHCf49iDO5+LLWiBDXm595lYnCJk3DrLjrEA6Q
	 /mD5wvfXydYulDxun4BzXXetiDlLcb/rvAFBiYdc=
Date: Thu, 27 Nov 2025 14:26:22 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-remove-abort-functionality-and-support-state-refresh.patch removed from -mm tree
Message-Id: <20251127222622.8C130C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: remove abort functionality and support state refresh
has been removed from the -mm tree.  Its filename was
     kho-remove-abort-functionality-and-support-state-refresh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: remove abort functionality and support state refresh
Date: Fri, 14 Nov 2025 13:59:58 -0500

Previously, KHO required a dedicated kho_abort() function to clean up
state before kho_finalize() could be called again.  This was necessary to
handle complex unwind paths when using notifiers.

With the shift to direct memory preservation, the explicit abort step is
no longer strictly necessary.

Remove kho_abort() and refactor kho_finalize() to handle re-entry.  If
kho_finalize() is called while KHO is already finalized, it will now
automatically clean up the previous memory map and state before generating
a new one.  This allows the KHO state to be updated/refreshed simply by
triggering finalize again.

Update debugfs to return -EINVAL if userspace attempts to write 0 to the
finalize attribute, as explicit abort is no longer supported.

Link: https://lkml.kernel.org/r/20251114190002.3311679-10-pasha.tatashin@soleen.com
Suggested-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Vasilevsky <dave@vasilevsky.ca>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c          |   21 +++---------------
 kernel/liveupdate/kexec_handover_debugfs.c  |    2 -
 kernel/liveupdate/kexec_handover_internal.h |    1 
 3 files changed, 5 insertions(+), 19 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-remove-abort-functionality-and-support-state-refresh
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1232,21 +1232,6 @@ void kho_restore_free(void *mem)
 }
 EXPORT_SYMBOL_GPL(kho_restore_free);
 
-int kho_abort(void)
-{
-	if (!kho_enable)
-		return -EOPNOTSUPP;
-
-	guard(mutex)(&kho_out.lock);
-	if (!kho_out.finalized)
-		return -ENOENT;
-
-	kho_update_memory_map(NULL);
-	kho_out.finalized = false;
-
-	return 0;
-}
-
 static int __kho_finalize(void)
 {
 	void *root = kho_out.fdt;
@@ -1297,8 +1282,10 @@ int kho_finalize(void)
 		return -EOPNOTSUPP;
 
 	guard(mutex)(&kho_out.lock);
-	if (kho_out.finalized)
-		return -EEXIST;
+	if (kho_out.finalized) {
+		kho_update_memory_map(NULL);
+		kho_out.finalized = false;
+	}
 
 	ret = __kho_finalize();
 	if (ret)
--- a/kernel/liveupdate/kexec_handover_debugfs.c~kho-remove-abort-functionality-and-support-state-refresh
+++ a/kernel/liveupdate/kexec_handover_debugfs.c
@@ -87,7 +87,7 @@ static int kho_out_finalize_set(void *da
 	if (val)
 		return kho_finalize();
 	else
-		return kho_abort();
+		return -EINVAL;
 }
 
 DEFINE_DEBUGFS_ATTRIBUTE(kho_out_finalize_fops, kho_out_finalize_get,
--- a/kernel/liveupdate/kexec_handover_internal.h~kho-remove-abort-functionality-and-support-state-refresh
+++ a/kernel/liveupdate/kexec_handover_internal.h
@@ -24,7 +24,6 @@ extern unsigned int kho_scratch_cnt;
 
 bool kho_finalized(void);
 int kho_finalize(void);
-int kho_abort(void);
 
 #ifdef CONFIG_KEXEC_HANDOVER_DEBUGFS
 int kho_debugfs_init(void);
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

