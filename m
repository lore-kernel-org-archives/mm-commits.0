Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1922E040D
	for <mm-commits@vger.kernel.org>; Sat, 25 Apr 2026 22:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777154826; cv=none; b=BQOQEhrMyXN0XHcMH/btzZF7vSDi664qKNhTYe6HLgJBDNpLxDc5EZ2IGZaEFpcGVMtuFnsbu5gzdxn9b42DTDHDMLwH7amsiMNwlvUerhTSdvhEOiRCJNLyQrgwDfkHEVZ64PRqi4sFOPw2h8Sx8eNnxHAiEPWMsU+D35L4Gx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777154826; c=relaxed/simple;
	bh=i6tQFUYqbN23r8QqS4yQmXNNqojqZGZlEWqHLQ7pJPI=;
	h=Date:To:From:Subject:Message-Id; b=ffJtZBd1iM5odYcQcbdNfynwxZPuZvr2CAoGNHfnmpUi2qTNNCRfQy5I2HZcdcR14NexrU3ObN01qADrn2Bk6bBNspK0yFk7EGICT5BqRpNa7Ko4pIG3uXPFoM39iUKLfOuq53CqV0Ebtjit1fdZoojXfdaPcTqYzS9VoKtGPr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vDAqdt15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vDAqdt15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73734C2BCB0;
	Sat, 25 Apr 2026 22:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777154826;
	bh=i6tQFUYqbN23r8QqS4yQmXNNqojqZGZlEWqHLQ7pJPI=;
	h=Date:To:From:Subject:From;
	b=vDAqdt15E6q13Dzj7cnQOuPD+VG4URDlQXB5nJquZESPbPpyGrwBs319QTA1FWl3x
	 AY4JjVCykoXzFlWazx2crPW0RI6lQrix7pXItyNoywQshSkrkQw6ncYTre6fzjP0iZ
	 SufZ3wYhsT36ZTLq54HuDjzjiUFfIshdiQhtc5zs=
Date: Sat, 25 Apr 2026 15:07:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs.patch removed from -mm tree
Message-Id: <20260425220706.73734C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
has been removed from the -mm tree.  Its filename was
     fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
Date: Thu, 23 Apr 2026 22:49:13 -0400

READ_ONLY_THP_FOR_FS is no longer present, remove related comment.

Link: https://lore.kernel.org/20260424024915.28758-11-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Sterba <dsterba@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/defrag.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/btrfs/defrag.c~fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs
+++ a/fs/btrfs/defrag.c
@@ -860,9 +860,6 @@ again:
 		return folio;
 
 	/*
-	 * Since we can defragment files opened read-only, we can encounter
-	 * transparent huge pages here (see CONFIG_READ_ONLY_THP_FOR_FS).
-	 *
 	 * The IO for such large folios is not fully tested, thus return
 	 * an error to reject such folios unless it's an experimental build.
 	 *
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-remove-read_only_thp_for_fs-in-khugepaged.patch
selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch

