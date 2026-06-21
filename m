Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485CB366052
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067123; cv=none; b=HHVkDexjytNlAJAUKbF6fL2xAMC1VeBl4eHw9klfIxJHyXjRexFKcJREC7td8tDtooML8GjSr/wMot/ymFOHU1Dr897Ga8X9JTnS7PnO7YxhVBx3oRjytUQJsrwswObOP0W7UjpzCd+yV1M1lgHQH2qfAqrw5Ltw8JesXwCFIZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067123; c=relaxed/simple;
	bh=HnWLEupp7Fk7eIezgQ/kRuIAF/EZnb6APDid/UNG8v4=;
	h=Date:To:From:Subject:Message-Id; b=kL7ubPlL2FvtPLYQQtsXhsEC6V/IxZnoQqUj2Ktk1rjpqP2GapDEB8ahECqNr661rUa4BNIRknEMkOA4UN0aC36s9exyAWX9vTQxr8eI3clkW8kA1F6zeFJytOSmY1L+/St934JO9YtjsGzdWXhP9uCaEnrA5UMGA+wz2OxNYqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V0bnCkrq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V0bnCkrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2568A1F00A3A;
	Sun, 21 Jun 2026 18:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067122;
	bh=norZxXxC/FZi0av02sqXtqCgq5el/QdlMrYwxkQ5ue8=;
	h=Date:To:From:Subject;
	b=V0bnCkrqbUY7TnJzPVEDQax+fT3yQ1phhFNyo1g80EnoC2qEgk+/UUh6kXNkIt/n0
	 Llqc1xEseKEEz5dEDPz1mpRIfWXRxjlTatxiJCqP4dF/+Xl3LsIynXa8en/wjC/6dQ
	 QC4m4RfPSYtACfaj0ekzLQMgDoQ+H804AHoWrUrg=
Date: Sun, 21 Jun 2026 11:38:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-migration-properly-cleanup-forked-processes.patch removed from -mm tree
Message-Id: <20260621183842.2568A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: migration: properly cleanup fork()ed processes
has been removed from the -mm tree.  Its filename was
     selftests-mm-migration-properly-cleanup-forked-processes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: migration: properly cleanup fork()ed processes
Date: Mon, 11 May 2026 19:27:48 +0300

Several migration test use fork() to create worker processes.  These
processes are later killed, but nothing collects their exit status and
they remain as zombies in the system.

Add a helper function that kills the worker processes, waitpid()s for them
and verifies the exit status.

Replace the loops that call kill() for each process with a call to that
helper.

Link: https://lore.kernel.org/20260511162840.375890-5-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reported-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/migration.c |   47 +++++++++++++++++------
 1 file changed, 35 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/mm/migration.c~selftests-mm-migration-properly-cleanup-forked-processes
+++ a/tools/testing/selftests/mm/migration.c
@@ -67,6 +67,29 @@ FIXTURE_TEARDOWN(migration)
 	free(self->pids);
 }
 
+static bool kill_children(FIXTURE_DATA(migration) * self)
+{
+	bool err = false;
+	pid_t pid;
+	int i;
+
+	for (i = 0; i < self->nthreads; i++) {
+		int status = 0;
+
+		pid = self->pids[i];
+		if (pid < 0)
+			continue;
+		if (kill(pid, SIGTERM))
+			err = true;
+		if (pid != waitpid(pid, &status, 0))
+			err = true;
+		if (!WIFSIGNALED(status) || WTERMSIG(status) != SIGTERM)
+			err = true;
+	}
+
+	return !err;
+}
+
 int migrate(uint64_t *ptr, int n1, int n2)
 {
 	int ret, tmp;
@@ -151,7 +174,7 @@ TEST_F_TIMEOUT(migration, shared_anon, 2
 {
 	pid_t pid;
 	uint64_t *ptr;
-	int i;
+	int i, err;
 
 	ptr = mmap(NULL, TWOMEG, PROT_READ | PROT_WRITE,
 		MAP_SHARED | MAP_ANONYMOUS, -1, 0);
@@ -171,9 +194,9 @@ TEST_F_TIMEOUT(migration, shared_anon, 2
 		}
 	}
 
-	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads; i++)
-		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
+	err = migrate(ptr, self->n1, self->n2);
+	ASSERT_EQ(kill_children(self), true);
+	ASSERT_EQ(err, 0);
 }
 
 /*
@@ -217,7 +240,7 @@ TEST_F_TIMEOUT(migration, shared_anon_th
 	uint64_t pmdsize;
 	pid_t pid;
 	uint64_t *ptr;
-	int i;
+	int i, err;
 
 	if (!thp_is_enabled())
 		SKIP(return, "Transparent Hugepages not available");
@@ -247,9 +270,9 @@ TEST_F_TIMEOUT(migration, shared_anon_th
 		}
 	}
 
-	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads; i++)
-		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
+	err = migrate(ptr, self->n1, self->n2);
+	ASSERT_EQ(kill_children(self), true);
+	ASSERT_EQ(err, 0);
 }
 
 /*
@@ -287,7 +310,7 @@ TEST_F_TIMEOUT(migration, shared_anon_ht
 	unsigned long hugepage_size;
 	pid_t pid;
 	uint64_t *ptr;
-	int i;
+	int i, err;
 
 	hugepage_size = default_huge_page_size();
 	if (!hugepage_size)
@@ -311,9 +334,9 @@ TEST_F_TIMEOUT(migration, shared_anon_ht
 		}
 	}
 
-	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads; i++)
-		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
+	err = migrate(ptr, self->n1, self->n2);
+	ASSERT_EQ(kill_children(self), true);
+	ASSERT_EQ(err, 0);
 }
 
 TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from rppt@kernel.org are


