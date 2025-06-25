Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FCD217707
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 22:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750892163; cv=none; b=EhYoY/RDsPSOmCpIFWZyM09H9qKDs8G2q12O+uQvD8e9tVzrGKYZw3A6Hej7HaHX0y7TQjdrRlWAD9HBcBpZxdypTUyTpu4tdr/ifWT0WHTy5RLCCqXtwQNypmnEGt88bIDaMPF+RGMX/w+oRPHiD/bd5nt670OI739bCuMeNsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750892163; c=relaxed/simple;
	bh=AcWt343lF2v+U0l63ZyeSJPaig1qUlVkRk3GIKkNbsM=;
	h=Date:To:From:Subject:Message-Id; b=uDja5oYmF+9LKj4yHbP+UI3hi52lRYXd04j5LF1mYcAMbqMTTyCtBh6AHzCc4ptq+iNc4NGAiCzuE6+ub+f8nvHF3hwBfzIvzRhJZu6OPGuupl0nLzuG+v3h+1oUMnQpW03o0Y+C0oAA2twZMGvsvBwxxtvZnx1XKI3zjrxoSac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J1Q2dnHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J1Q2dnHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35245C4CEEA;
	Wed, 25 Jun 2025 22:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750892163;
	bh=AcWt343lF2v+U0l63ZyeSJPaig1qUlVkRk3GIKkNbsM=;
	h=Date:To:From:Subject:From;
	b=J1Q2dnHOES5jY9rYlRFxF9clefBjNfO5yjZwTzHzBkSSgQAAu9dj1Bpi1zK5NKGja
	 p2mxauiCA1yDqFl3mjeyQTY4/QXtDIq3hNfp3JT8kFrY48EvNWdOHZ3wB4t8Rjz7Lf
	 Tpv5JEfaSpAJ6RvHgfwQ2KTTakwOZwuZLaPidd/k=
Date: Wed, 25 Jun 2025 15:56:02 -0700
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] crashdump-add-config_keys-dependency.patch removed from -mm tree
Message-Id: <20250625225603.35245C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crashdump: add CONFIG_KEYS dependency
has been removed from the -mm tree.  Its filename was
     crashdump-add-config_keys-dependency.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: crashdump: add CONFIG_KEYS dependency
Date: Fri, 20 Jun 2025 13:21:22 +0200

The dm_crypt code fails to build without CONFIG_KEYS:

kernel/crash_dump_dm_crypt.c: In function 'restore_dm_crypt_keys_to_thread_keyring':
kernel/crash_dump_dm_crypt.c:105:9: error: unknown type name 'key_ref_t'; did you mean 'key_ref_put'?

There is a mix of 'select KEYS' and 'depends on KEYS' in Kconfig,
so there is no single obvious solution here, but generally using 'depends on'
makes more sense and is less likely to cause dependency loops.

Link: https://lkml.kernel.org/r/20250620112140.3396316-1-arnd@kernel.org
Fixes: 62f17d9df692 ("crash_dump: retrieve dm crypt keys in kdump kernel")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Vasilevsky <dave@vasilevsky.ca>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Kconfig.kexec |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/Kconfig.kexec~crashdump-add-config_keys-dependency
+++ a/kernel/Kconfig.kexec
@@ -134,6 +134,7 @@ config CRASH_DM_CRYPT
 	depends on KEXEC_FILE
 	depends on CRASH_DUMP
 	depends on DM_CRYPT
+	depends on KEYS
 	help
 	  With this option enabled, user space can intereact with
 	  /sys/kernel/config/crash_dm_crypt_keys to make the dm crypt keys
_

Patches currently in -mm which might be from arnd@arndb.de are

lib-test_hmm-reduce-stack-usage.patch
lib-test_objagg-split-test_hints_case-into-two-functions.patch

