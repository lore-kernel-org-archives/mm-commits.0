Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF5E38F923;
	Mon,  6 Apr 2026 18:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775499259; cv=none; b=VgOhKNT6RRrsbi9AWlrtxkrNi8AHDr9Wb5PNugkUUBd6xIjlSiinFCcuvjXsJkhhwEH6PynacYr/s7OBc095YDNNzNB0kO7pPTcMy6RrWusjICsqOD/09iMO9ABWWofP8mADmcsT5uIMtM5ANpHVQ48BPxWbYd/Clj3ZgRMWKkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775499259; c=relaxed/simple;
	bh=eOtEj6rTNQrDBznFdsCxoHQPceOUYn2ZkiE3UeTeemo=;
	h=Date:To:From:Subject:Message-Id; b=SSX6O0vJ++fIUJlHiVki+hcaFAjAd1S1iip+gE3g1empDh3PhItUJ3oin9vzE//PfA7Akd3Pd9s4fh5Uk98HrdfS5aBHUv05k/jREZPgzxI7sIYFDc7898HiEPweP6OCiVVhlV3yR5ds2UMHuuvegwlt4uA2kbEYhFzpQeMUXUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uVVciVuX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uVVciVuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48763C4CEF7;
	Mon,  6 Apr 2026 18:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775499259;
	bh=eOtEj6rTNQrDBznFdsCxoHQPceOUYn2ZkiE3UeTeemo=;
	h=Date:To:From:Subject:From;
	b=uVVciVuXAjAT7TYcEzrC2dLtIyHcgX6Nw0iFFRdqHAIuUycnsBG/NtyaAKy/wHgje
	 Gi/chZfAIGJb3XdY2DZ5JnDcfLYOcnuHaz0FdpsNfI1ltCn82DnXxOdmSqnzv/18gQ
	 ScMoNuT9MsT7QM6DLP+GiQaXyCexLMomAabTKNYg=
Date: Mon, 06 Apr 2026 11:14:18 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,leotimmins1974@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] liveupdate-propagate-file-deserialization-failures.patch removed from -mm tree
Message-Id: <20260406181419.48763C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate: propagate file deserialization failures
has been removed from the -mm tree.  Its filename was
     liveupdate-propagate-file-deserialization-failures.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Leo Timmins <leotimmins1974@gmail.com>
Subject: liveupdate: propagate file deserialization failures
Date: Wed, 25 Mar 2026 12:46:07 +0800

luo_session_deserialize() ignored the return value from
luo_file_deserialize().  As a result, a session could be left partially
restored even though the /dev/liveupdate open path treats deserialization
failures as fatal.

Propagate the error so a failed file deserialization aborts session
deserialization instead of silently continuing.

Link: https://lkml.kernel.org/r/20260325044608.8407-1-leotimmins1974@gmail.com
Link: https://lkml.kernel.org/r/20260325044608.8407-2-leotimmins1974@gmail.com
Fixes: 16cec0d26521 ("liveupdate: luo_session: add ioctls for file preservation")
Signed-off-by: Leo Timmins <leotimmins1974@gmail.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_session.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/liveupdate/luo_session.c~liveupdate-propagate-file-deserialization-failures
+++ a/kernel/liveupdate/luo_session.c
@@ -558,8 +558,13 @@ int luo_session_deserialize(void)
 		}
 
 		scoped_guard(mutex, &session->mutex) {
-			luo_file_deserialize(&session->file_set,
-					     &sh->ser[i].file_set_ser);
+			err = luo_file_deserialize(&session->file_set,
+						   &sh->ser[i].file_set_ser);
+		}
+		if (err) {
+			pr_warn("Failed to deserialize files for session [%s] %pe\n",
+				session->name, ERR_PTR(err));
+			return err;
 		}
 	}
 
_

Patches currently in -mm which might be from leotimmins1974@gmail.com are


