Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793852871;
	b=oBcRXDgXVsqVjeqgFPWm20lJaMdCc6xwa5Fp/dMcaQUnec8pwzA1pX4X+7oD1CwASw7a
	 SX0E/eY5E9xkkV1vSleQsgA9EAb5OTTctGgFnF1PdQ1pzGDJG6onUiYrALM81lR14wUWw
	 UeQufXGuljIoyF5AHIIpx2ATDhaEFzE+6379YLJQ7M10Elq165Q2VnP/mp/ucxjWWdFNY
	 CHl+4T76Lcs4bKPEme/NQQcCFDVUxarYG37vUUN7A8VFICIbmzg2St524NrX9y/5JlYmr
	 OViB9kNErHhSFll4m5YmXwcE2TfWrZFb2NI2iETP5geXm8xP7rmB85w7te8w7sqIoAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793852871;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:X-Mailer:
	 Mime-Version:Content-Type:Content-Transfer-Encoding;
	bh=u6F4KDCYBUQmf5Ux75AdWla2t2dBWZcV4odDQlEP7Vs=;
	b=QG3dLfAlvOSOEo3bV1XK68fD4o2CO5hcSIJAR2mLf+EOm+UYfCrk9LJ41hGX+iN+lA6A
	 Hu96AZFpmMGn11ZYzE7vWWRvl8fJphQ11fJICNpJilGU25tiV9S1CweTIcI4gyxhQuPC/
	 K5k3PAkLYTR5o8FaUYcBGGsZOabmjii1yN3gVg9KcSDDoTrGlEghi2FO0IjQFDdeWWnTf
	 lhFdOoaqm3SB+9qqX5Yiw17JapRSb0y6N/DSq57h0+D1ZjBCyMf0QDxHm1kms5zkrnWdU
	 2GwqZAuI+7+QvpQgh0gqw64/VaoSmXhX4MUSsAraIWwHfJZXWRmODtQNRFXhoEkG5yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FhLoRdgv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475F2606A328;
	Thu,  5 Nov 2026 04:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FhLoRdgv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD1C1F000C1;
	Thu,  5 Nov 2026 04:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793852871;
	bh=u6F4KDCYBUQmf5Ux75AdWla2t2dBWZcV4odDQlEP7Vs=;
	h=Date:From:To:Cc:Subject;
	b=FhLoRdgvhjhC76otaNKgvCnBlh7dz3VLrlFogfXeqxUzmIo8dzKfgv7TUuJgHfCuQ
	 yHBB4WIA1dCoWMDJSn1Yim2MmriTEV8tEPmmNiz2WJ8Plj+XcwpiMXA+FZFKZnJvAW
	 V1DGCzvuWmHm13mO+Jx4tyThJtjt/yPeXQ5XAFXk=
Date: Wed, 4 Nov 2026 20:27:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] non-MM hotfixes for 7.4-rc2
Message-Id: <20261104202749.a5b9ab39d3169f80b5089a14@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Linus, please merge this batch of others-than-MM hotfixes, thanks.


The following changes since commit 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4:

  Linux 7.4-rc1 (2026-11-01 13:26:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-hotfi=
xes-stable-2026-11-04-20-26

for you to fetch changes up to 5b4696e0bfc358619adaeab25ad35b4979af8331:

  ocfs2: cache the mount context for dentry lock callbacks (2026-11-02 19:1=
8:59 -0800)

----------------------------------------------------------------
mm.git review status for linus..mm-nonmm-hotfixes-stable

Everything:

Total patches:       22
Fixes: tags:         19
cc:stable patches:   17
Reviews/patch:       0.77
Reviewed rate:       68%

22 patches. 17 are cc:stable.

Most are OCFS2 fixes. These address extended-attribute corruption,
missing attributes and kernel BUGs, along with crashes during cluster
configuration, lock migration, recovery and unmount. Extent movement
is also fixed to validate its range against a stable file size.

Three FAT changes prevent a failed-write/FIBMAP race from spuriously
making the filesystem read-only, correct directory link counts after
rename, and speed up file expansion. The reported QEMU benchmarks show
particularly large improvements on synchronous mounts.

A taint-string fix prevents an out-of-bounds read which can expose slab
contents in the kernel log. There are also build fixes for OpenRISC
modules on CPUs without hardware multiply and for Clang 24.

----------------------------------------------------------------
Andrew Morton (2):
      openrisc: export __mulsi3 for modules
      MAINTAINERS: add an IPC entry

Cen Zhang (7):
      ocfs2: validate move extents against a stable EOF
      ocfs2: keep locking_state within the cluster connection lifetime
      ocfs2/dlm: serialize migration MLE cleanup on failure
      ocfs2: stop recovery before shutting down local allocators
      ocfs2/cluster: unlink socket containers before releasing resources
      ocfs2: wait for filecheck kobject release after a failed add
      ocfs2: cache the mount context for dentry lock callbacks

Cl=E9ment L=E9ger (1):
      MAINTAINERS: mailmap: use Cl=E9ment L=E9ger's linux.dev mail address

Eklavya Singh (1):
      ocfs2/heartbeat: serialize concurrent writes to a region's dev attrib=
ute

Hungyu Lin (1):
      fat: fix parent link count when replacing a sibling directory

Joseph Qi (6):
      ocfs2: read the xattr entry hash before defragmenting the bucket
      ocfs2: find the xattr entry again after defragmenting a bucket
      ocfs2: find the xattr entry again after converting a block to a bucket
      ocfs2: do not read the entry array of an empty xattr bucket
      ocfs2: do not index before the entry array when dividing an empty buc=
ket
      ocfs2: do not read the entry array of an empty xattr block

Matheus Alves de Almeida (2):
      fat: preallocate space before expanding in fat_cont_expand()
      fat: hold truncate_lock in fat_write_failed()

Nathan Chancellor (1):
      lib/base64: silence clang-24 -Wconstant-conversion with diag pragmas

Nickolai Zeldovich (1):
      panic: zero the dynamically allocated taint buffer

 .mailmap                          |   4 ++
 MAINTAINERS                       |  14 +++-
 arch/openrisc/kernel/or32_ksyms.c |   1 +
 fs/fat/dir.c                      |  10 +++
 fs/fat/fat.h                      |   1 +
 fs/fat/file.c                     |  70 +++++++++++++-----
 fs/fat/inode.c                    |   2 +
 fs/fat/namei_msdos.c              |   9 +--
 fs/fat/namei_vfat.c               |   9 +--
 fs/ocfs2/cluster/heartbeat.c      |  40 +++++++++--
 fs/ocfs2/cluster/tcp.c            |   5 +-
 fs/ocfs2/dcache.h                 |   5 +-
 fs/ocfs2/dlm/dlmmaster.c          |  70 +++++++++++++++---
 fs/ocfs2/dlmglue.c                |  34 ++++-----
 fs/ocfs2/filecheck.c              |   2 +
 fs/ocfs2/journal.c                |  15 +++-
 fs/ocfs2/journal.h                |   1 +
 fs/ocfs2/move_extents.c           |  70 ++++++++++--------
 fs/ocfs2/super.c                  |   3 +
 fs/ocfs2/xattr.c                  | 146 ++++++++++++++++++++++++++++++++--=
----
 kernel/panic.c                    |   2 +-
 lib/base64.c                      |   3 +
 22 files changed, 388 insertions(+), 128 deletions(-)

