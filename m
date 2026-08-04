Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36640423E93
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816315; cv=none; b=LOZG+etycKwQ4W957oefVAW/1S9QVlZhgnntJwlaMnuDKjS8CcvlqiAYIm0/ujmd0NvDBJDs1HKMDAKk4OWu+3wax7rYgAkPO1lR+8217TRrPk+4A3oCawaIMpMNFrUwrJVsA+dBOtChBqva0jwlY/NoCBdrg1llFd80GSNrMSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816315; c=relaxed/simple;
	bh=Dcnl2oWxzo5myOaNTPHimfBH6hzMpQc8VSV+bdHhR28=;
	h=Date:To:From:Subject:Message-Id; b=CCj9X1mZIwDh8nolsg5zhrOtS4AAeDFIGFQfjNFczEsNCdaToB8b/fu65ihiw+/smf1gU0i5LUcHzimP4Bg5Em13dgCykqi5OxTcBaaq20jc8/oNyyRPrXhOq9eJpI54I/JT7iHExFDGD1aMeNqJhAE6cchpiCPhQgcwwKOrgs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UOPvvuIJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UOPvvuIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085671F00A3A;
	Tue,  4 Aug 2026 04:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816314;
	bh=iON7JBrwjAAfqV5DR6bxK+9Vbb/s4OAeZZaasDLLbrM=;
	h=Date:To:From:Subject;
	b=UOPvvuIJpGR7XC9N04YDYLw7PH4ta3n3jMft++w+pwy3tcZCTUO7ozONZTmXScj3T
	 xSlT3P6MUUtKsIW9PF6xsaPVXTtkOnEYe1rgPHYHI5s3rRYoVCLW9gBD6bLWYYARRE
	 B8SAvHqSY2/c0qN3hEEHhg5sS/ncO0KhQH1YMz5A=
Date: Mon, 03 Aug 2026 21:05:13 -0700
To: mm-commits@vger.kernel.org,balbirs@nvidia.com,cyyzero16@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] taskstats-remove-dead-taskstats_exit_mutex-declaration.patch removed from -mm tree
Message-Id: <20260804040514.085671F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: taskstats: remove dead taskstats_exit_mutex declaration
has been removed from the -mm tree.  Its filename was
     taskstats-remove-dead-taskstats_exit_mutex-declaration.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yiyang Chen <cyyzero16@gmail.com>
Subject: taskstats: remove dead taskstats_exit_mutex declaration
Date: Tue, 7 Jul 2026 22:52:05 +0800

The extern declaration of taskstats_exit_mutex has never been defined nor
referenced anywhere now.  Just remove it.

Link: https://lore.kernel.org/98948e69094b73d6dfa63dcf0770067b57f3becf.1783435695.git.cyyzero16@gmail.com
Signed-off-by: Yiyang Chen <cyyzero16@gmail.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/taskstats_kern.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/taskstats_kern.h~taskstats-remove-dead-taskstats_exit_mutex-declaration
+++ a/include/linux/taskstats_kern.h
@@ -14,7 +14,6 @@
 
 #ifdef CONFIG_TASKSTATS
 extern struct kmem_cache *taskstats_cache;
-extern struct mutex taskstats_exit_mutex;
 
 static inline void taskstats_tgid_free(struct signal_struct *sig)
 {
_

Patches currently in -mm which might be from cyyzero16@gmail.com are


