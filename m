Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB27274B53
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338700; cv=none; b=U7aL37hHNuRuvr6rD55Xw9cqDrp8oB5/HNZ++bEoItcur6CqOsQhYoNitFlxP9YWS65+EQSNlDOB3CBdXivm1nqmzY8K4x0GJOJFcGpbe0pIoKPRZ7jzqSsfjcoqO6+VT1GUbmyveIg5JVwkH8nMb40Tjbre3YPD0BTVPgnh5GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338700; c=relaxed/simple;
	bh=Xg4pEiRP6cYPgfLhthcuH0kD9NBMgD9gmAUM8+PTs7E=;
	h=Date:To:From:Subject:Message-Id; b=Z4JsdQWTGNHfeDlpGG4b6VQetKYpnB+4bypcCm3/v4tyaYgherX0882k4m9fHFUIzOoP92pOWZVFonZtp2wtyy83XeELkz+0ZsJ+ZthSmIEG27IKOL+P6yoT6maiyjSuglSEGUhHlq3EpdzdaK/46zsSQKNGO/DlPBrDZvbR+do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B+FFGEC8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B+FFGEC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A157F1F0089C;
	Wed,  7 Oct 2026 02:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338699;
	bh=4SnvG4xZbg+zqfwBfMETr7acpUtfgo6AG81MVyszu7I=;
	h=Date:To:From:Subject;
	b=B+FFGEC8jRTc7eNu1fTEFm6gwnveH2Up5VztKuIA0EgyomX1A+1P5R4lcNVh2JVmm
	 USFPNhkjsw2lIgDRo7HfLXzZrrWE+4U88eXDHyX2y3ZjJW6a1rZMGrQV4QjtF9TXu5
	 oHcYoxv2K4Uw8Q3rYc3Ot3pB8tWHwfPCu6+PCke8=
Date: Tue, 06 Oct 2026 19:04:59 -0700
To: mm-commits@vger.kernel.org,mhiramat@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] bootconfig-remove-redundant-assignment-in-xbc_parse_array.patch removed from -mm tree
Message-Id: <20261007020459.A157F1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bootconfig: remove redundant assignment in xbc_parse_array()
has been removed from the -mm tree.  Its filename was
     bootconfig-remove-redundant-assignment-in-xbc_parse_array.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: bootconfig: remove redundant assignment in xbc_parse_array()
Date: Fri, 11 Sep 2026 01:30:48 +0900

After the loop, node is the last array value that xbc_add_child() added,
and xbc_parse_array() sets node->child to 0.

xbc_init_node() already set node->child to 0 when the value was
added, and node->child is not modified after that, so the assignment
is redundant.

So remove the assignment.

No functional change.

Link: https://lore.kernel.org/20260910163051.1973775-1-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
---

 lib/bootconfig.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/bootconfig.c~bootconfig-remove-redundant-assignment-in-xbc_parse_array
+++ a/lib/bootconfig.c
@@ -836,7 +836,6 @@ static int __init xbc_parse_array(char *
 			return -ENOMEM;
 		*__v = next;
 	} while (c == ',');
-	node->child = 0;
 
 	return c;
 }
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-swapops-remove-unused-is_hwpoison_entry.patch
init-mainc-remove-unreachable-check-in-obsolete_checksetup.patch

