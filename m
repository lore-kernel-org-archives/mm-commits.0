Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832447;
	b=jonBILb7d3D3gpE/bOJXMaFnEF7J3HvQZkb9BgE2vqnABu7uaRfPwszXx5SzVWjYzi/s
	 fYeylh5wZI7xK+7JLY6P+jo9x1uj4E9QX7ZZtQ8QAmCv0jfEK6ShdeNvLltMmdYqFCvQ9
	 9CWms6/wt2ywI7NqQJU53YcNbReXjm+VM6HPHmBXNFDmP42JB+afhQ4GIOIC4RNZzZ9wT
	 l29jeyznpCop7rE9+aor6ls62FCBdaAB5IJzX8k3U95TR6d8UuKcJfREosAvIOwZ5Rnqw
	 77PThoLffI/C/XEnvNBKJ0Xpt6YXUFCxAA3xTAkRrORczE1hBbFAlNYu7t+Cxt8bhiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832447;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=qHO6mT/29LSy7wgcjzcNYw2gB12xuRroycGmQdtOlQE=;
	b=t/G5ysE0n/qTLn1n5GCe8Wcl5ql2MmvXEt0Lzv0p8/H9Zq/7IAYX6I0sijZxiPr02qQn
	 stwSDiw7ncSIM8tv63yk6m/i+X5+waOnJIHZWfvVGmgU9vpdP/zF6YpepR+rRTwXzOqP1
	 zUygAcZ9dLeqnMz262Zqd4EtgqOyzWmywq9MOH5ZqjJpTI5mnR5R2bgb9ix6KAyN1IGYv
	 SEHXqYWMlukmKyD56vgLvylmWnYBZT21pXQ3EfWGXIgscxpwS9GXs+5oVzVLOlc5W0+KT
	 EfXxErwfvF4Y3MBaG6nIyfTjyAcFqTsB2YtohQnWjrE8KYGLZ7MiQAvzs+xAuiDCFbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Rs7x6whu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D36606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Rs7x6whu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28AF1F01828;
	Sat, 24 Oct 2026 09:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832446;
	bh=qHO6mT/29LSy7wgcjzcNYw2gB12xuRroycGmQdtOlQE=;
	h=Date:To:From:Subject;
	b=Rs7x6whu9FxRxjp/5kRcWP7onf6yVZKkFlXXpPiMNlOnDDxb0zY2URESzcRlgmUsH
	 YfJ4ypYAoBrVO17aTTIdUjCrjGvW3wdKwzWMSZet4Mg8dTDtTdSYzsocF/RJwh07Im
	 hW4GKNNrr6dTFP1IOl4CYCBO6WedFK6yD/PxfSRk=
Date: Sat, 24 Oct 2026 02:00:46 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@arm.com,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,brauner@kernel.org,jm5905938@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-mrelease_test-fix-retry-limit.patch removed from -mm tree
Message-Id: <20261024090046.C28AF1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: selftests/mm: mrelease_test: fix retry limit
has been removed from the -mm tree.  Its filename was
     selftests-mm-mrelease_test-fix-retry-limit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Aveline Noir <jm5905938@gmail.com>
Subject: selftests/mm: mrelease_test: fix retry limit
Date: Wed, 30 Sep 2026 23:00:27 -0700

mrelease_test doubles the child allocation when process_mrelease() returns
ESRCH.

When size is already MAX_SIZE_MB, the current <= check still allows
another retry, causing the allocation to grow from 1024 MB to 2048 MB.

Use < instead of <= so the largest allocation attempted remains
MAX_SIZE_MB.

LLM used in discovering bug. Changes were made and reviewed manually.

Link: https://lore.kernel.org/CANOyQmFzsssM_BXHUDrV+UuVD5SZMBmSkg3UQnmw9Ns1PV7GCQ@mail.gmail.com
Fixes: 33776141b812 ("selftests: vm: add process_mrelease tests")
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Assisted-by: LLM
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
---

 tools/testing/selftests/mm/mrelease_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mrelease_test.c~selftests-mm-mrelease_test-fix-retry-limit
+++ a/tools/testing/selftests/mm/mrelease_test.c
@@ -157,7 +157,7 @@ retry:
 		 * Retry until we succeed or reach MAX_SIZE_MB.
 		 */
 		if (errno == ESRCH) {
-			retry = (size <= MAX_SIZE_MB);
+			retry = (size < MAX_SIZE_MB);
 		} else {
 			waitpid(pid, NULL, 0);
 			ksft_exit_fail_msg("process_mrelease: %s\n", strerror(errno));
_

Patches currently in -mm which might be from jm5905938@gmail.com are


