Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3A428DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489813; cv=none; b=h8lCVNca8QvCuYnXglojKmS6IHQY3ltPxf9GHoao++r4X8Gz2fm6L6ahWdOEwgT3+++VkX+cauEPOcU9AyGmcsuf3lPbJmMTS0bSb4L0RCCo4UwbAxZ6urDoH5IFe4PWvSDIT4A+e9r/6CsRCBsaK8D1Rhm9BZgQOIPNwYu63kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489813; c=relaxed/simple;
	bh=fIm9Rw1adfRKMcoLge6NoWicy4IdY8wGdwNWVcX8voE=;
	h=Date:To:From:Subject:Message-Id; b=Sa3pY/KRNzAnpyDO+4i8q5JSeOuX4SbqBcoUFvHYl7EuepesB4q63KM2S7tAy9hHIMbhArrnK8v6i9LkPYcgLX//c5Fm/6Eye7+voVS+ZbSj3FXlkg+IM8LymiTEdq83nQF80QxC3JnH1BVlyB4I3c6aeFkldeL+omd5qPjOqZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=km+cC9bw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="km+cC9bw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B74C4CEE7;
	Sun, 21 Sep 2025 21:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489812;
	bh=fIm9Rw1adfRKMcoLge6NoWicy4IdY8wGdwNWVcX8voE=;
	h=Date:To:From:Subject:From;
	b=km+cC9bwJAou97M/6e7qzh2NEbcK0s6088uJxDZMeUBupEi5PxE54flPnVsCDWc05
	 yHESWvDpFEz84k/wBKf4RernoKQ4TGdG9fHtsY6+POjGwB4yIK67wTNy9UWKOPvVGj
	 rcpln24V0NFz19rIEOu2h+1Lks8bPGVaHpts1AdI=
Date: Sun, 21 Sep 2025 14:23:32 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,Jason@zx2c4.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] wireguard-selftests-remove-config_sparsemem_vmemmap=y-from-qemu-kernel-config.patch removed from -mm tree
Message-Id: <20250921212332.D9B74C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: wireguard: selftests: remove CONFIG_SPARSEMEM_VMEMMAP=y from qemu kernel config
has been removed from the -mm tree.  Its filename was
     wireguard-selftests-remove-config_sparsemem_vmemmap=y-from-qemu-kernel-config.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: wireguard: selftests: remove CONFIG_SPARSEMEM_VMEMMAP=y from qemu kernel config
Date: Mon, 1 Sep 2025 17:03:26 +0200

It's no longer user-selectable (and the default was already "y"), so let's
just drop it.

It was never really relevant to the wireguard selftests either way.

Link: https://lkml.kernel.org/r/20250901150359.867252-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/wireguard/qemu/kernel.config |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/wireguard/qemu/kernel.config~wireguard-selftests-remove-config_sparsemem_vmemmap=y-from-qemu-kernel-config
+++ a/tools/testing/selftests/wireguard/qemu/kernel.config
@@ -48,7 +48,6 @@ CONFIG_JUMP_LABEL=y
 CONFIG_FUTEX=y
 CONFIG_SHMEM=y
 CONFIG_SLUB=y
-CONFIG_SPARSEMEM_VMEMMAP=y
 CONFIG_SMP=y
 CONFIG_SCHED_SMT=y
 CONFIG_SCHED_MC=y
_

Patches currently in -mm which might be from david@redhat.com are


