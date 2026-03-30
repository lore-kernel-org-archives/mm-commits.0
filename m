Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4972E7F39
	for <mm-commits@vger.kernel.org>; Mon, 30 Mar 2026 19:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774898440; cv=none; b=FvbKXN5d5AtIusaKg7PT3q5Xt1xsOLQaHtRj7URqDp4+hLnIM6XOe/Te3HTqXoOdhQkS/kbFd//ZNRwee75AEv9rbgu4IRmfIZrNZwJQgOFul4Q/W7ArdEtvRPqVIXOFSBj/I6uGCyZ78kM6/knUKUhYkRU8hmHtId8GJtqUeks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774898440; c=relaxed/simple;
	bh=JIJ4FZPXisryZJ8X+RL/0RqiSkAO1ct5r+ML9pNF+DE=;
	h=Date:To:From:Subject:Message-Id; b=tiwubVmgA+s+aupocf8DJEMpWctWOrVgxBl/3PcW1T9w4GtqknGkPyu3BlpEa5tlQ+udO23xvGUEIFIaylnWZzbmMwR05cXKvLKG4ki7vpa6VUqv9ADpStBczIQaZy9l+jA1EirGvMcXTx4co8zqmj5eUuJFAdKxjOm4iJtyQqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OQa8IlLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OQa8IlLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C29C2BC9E;
	Mon, 30 Mar 2026 19:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774898439;
	bh=JIJ4FZPXisryZJ8X+RL/0RqiSkAO1ct5r+ML9pNF+DE=;
	h=Date:To:From:Subject:From;
	b=OQa8IlLTdOsxdf/XVqKdIzHNtkDlhsPEvyi+lYfs8j8Da9H3WdMRcK4mG73h20wcg
	 MTfP7p3aAOHygZRtOKVbpf2GF5heYsRMs2kHK2NpY/F6csad4PIflYLJQuen//XlIz
	 9ScsWCLgh6OFaWl00GLEZm3RdYk6JmghdFEVYofo=
Date: Mon, 30 Mar 2026 12:20:39 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-vm_util-robust-write_file-fix.patch removed from -mm tree
Message-Id: <20260330192039.92C29C2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-mm-vm_util-robust-write_file-fix
has been removed from the -mm tree.  Its filename was
     selftests-mm-vm_util-robust-write_file-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-vm_util-robust-write_file-fix
Date: Fri Mar 27 12:28:40 PM PDT 2026

add newline, per David

Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Chunyu Hu <chuhu@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-vm_util-robust-write_file-fix
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -769,6 +769,7 @@ void write_file(const char *path, const
 {
 	int fd, saved_errno;
 	ssize_t numwritten;
+
 	if (buflen < 1)
 		ksft_exit_fail_msg("Incorrect buffer len: %zu\n", buflen);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

liveupdate-initialize-incoming-flb-state-before-finish-fix.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

