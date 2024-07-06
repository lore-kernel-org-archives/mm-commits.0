Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E16E139CFC
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292048; cv=none; b=XmJXS+6z1Lz02C/lEokP4heiw7h46Q1YsbcPxCubT/6jMyASm9ajY9unV7II+SOD4cXq84hiCkzeJLq8bADlx5mFWhbgLs5HLGz2/69kYzNjXr7jvGuJL65IE4NpQfLn6vstiGTK7TAxTu7IPU5yO6vsW5KDtM1PRfpOdq7JEXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292048; c=relaxed/simple;
	bh=rMFyx/1oe42QwPjuhKOYp0z+6WxBm34dD/ORZNL74FA=;
	h=Date:To:From:Subject:Message-Id; b=rlR17MjtDNpG3PGgyqrNCinuhCo1/W9d9ZK6HW7CGE8DKqKykdHoUhwBFP33o6niwJkEZC89q8fKFhp1Tc/ahg+lu33wU75/a14EfXfhP2WMIJ2wmCJdMEdhs7kA6VzxbN7hptB9rF+xv8oR25ZZpl13IBaRSulGFStp9ndijHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EDxkN0DY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EDxkN0DY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB008C2BD10;
	Sat,  6 Jul 2024 18:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292047;
	bh=rMFyx/1oe42QwPjuhKOYp0z+6WxBm34dD/ORZNL74FA=;
	h=Date:To:From:Subject:From;
	b=EDxkN0DYZeQ3KXbCSwVoO8jAJ0RpRA33n37zL0oreu7KUIxmVWCnVcYcEEItpb7tG
	 vmEKlb6Ryu5TfRqBVIbDRRMn6IIzs8aQ4R2+9u4rgqO7zA0LZLuEtW3OYR/gJMRSAN
	 A/GZK9OYxhP+JsXL1YDQWHN1B3tARkhjEYWR3HTY=
Date: Sat, 06 Jul 2024 11:54:07 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-start-add-access-pattern-snapshot-example.patch removed from -mm tree
Message-Id: <20240706185407.DB008C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/start: add access pattern snapshot example
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-start-add-access-pattern-snapshot-example.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/start: add access pattern snapshot example
Date: Mon, 1 Jul 2024 12:27:00 -0700

DAMON user-space tool (damo) provides access pattern snapshot feature,
which is expected to be frequently used for real time access pattern
analysis.  The snapshot output is also showing what DAMON provides on its
own, including the 'age' information.

In contrast, the recorded access patterns, which is shown as an example
usage on the quick start section, shows what users can make from what
DAMON provided.  It includes information that generated outside of DAMON
and makes the 'age' concept bit unclear.  Hence snapshot output is easier
at understanding the raw realtime output of DAMON.  Add the snapshot usage
example on the quick start section.

Link: https://lkml.kernel.org/r/20240701192706.51415-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/start.rst |   46 +++++++++++++++--
 1 file changed, 42 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/damon/start.rst~docs-admin-guide-mm-damon-start-add-access-pattern-snapshot-example
+++ a/Documentation/admin-guide/mm/damon/start.rst
@@ -34,18 +34,56 @@ detail) of DAMON, you should ensure :doc
 mounted.
 
 
+Snapshot Data Access Patterns
+=============================
+
+The commands below show the memory access pattern of a program at the moment of
+the execution. ::
+
+    $ git clone https://github.com/sjp38/masim; cd masim; make
+    $ sudo damo start "./masim ./configs/stairs.cfg --quiet"
+    $ sudo ./damo show
+    0   addr [85.541 TiB  , 85.541 TiB ) (57.707 MiB ) access 0 %   age 10.400 s
+    1   addr [85.541 TiB  , 85.542 TiB ) (413.285 MiB) access 0 %   age 11.400 s
+    2   addr [127.649 TiB , 127.649 TiB) (57.500 MiB ) access 0 %   age 1.600 s
+    3   addr [127.649 TiB , 127.649 TiB) (32.500 MiB ) access 0 %   age 500 ms
+    4   addr [127.649 TiB , 127.649 TiB) (9.535 MiB  ) access 100 % age 300 ms
+    5   addr [127.649 TiB , 127.649 TiB) (8.000 KiB  ) access 60 %  age 0 ns
+    6   addr [127.649 TiB , 127.649 TiB) (6.926 MiB  ) access 0 %   age 1 s
+    7   addr [127.998 TiB , 127.998 TiB) (120.000 KiB) access 0 %   age 11.100 s
+    8   addr [127.998 TiB , 127.998 TiB) (8.000 KiB  ) access 40 %  age 100 ms
+    9   addr [127.998 TiB , 127.998 TiB) (4.000 KiB  ) access 0 %   age 11 s
+    total size: 577.590 MiB
+    $ sudo ./damo stop
+
+The first command of the above example downloads and builds an artificial
+memory access generator program called ``masim``.  The second command asks DAMO
+to execute the artificial generator process start via the given command and
+make DAMON monitors the generator process.  The third command retrieves the
+current snapshot of the monitored access pattern of the process from DAMON and
+shows the pattern in a human readable format.
+
+Each line of the output shows which virtual address range (``addr [XX, XX)``)
+of the process is how frequently (``access XX %``) accessed for how long time
+(``age XX``).  For example, the fifth region of ~9 MiB size is being most
+frequently accessed for last 300 milliseconds.  Finally, the fourth command
+stops DAMON.
+
+Note that DAMON can monitor not only virtual address spaces but multiple types
+of address spaces including the physical address space.
+
+
 Recording Data Access Patterns
 ==============================
 
 The commands below record the memory access patterns of a program and save the
 monitoring results to a file. ::
 
-    $ git clone https://github.com/sjp38/masim
-    $ cd masim; make; ./masim ./configs/zigzag.cfg &
+    $ ./masim ./configs/zigzag.cfg &
     $ sudo damo record -o damon.data $(pidof masim)
 
-The first two lines of the commands download an artificial memory access
-generator program and run it in the background.  The generator will repeatedly
+The line of the commands run the artificial memory access
+generator program again.  The generator will repeatedly
 access two 100 MiB sized memory regions one by one.  You can substitute this
 with your real workload.  The last line asks ``damo`` to record the access
 pattern in the ``damon.data`` file.
_

Patches currently in -mm which might be from sj@kernel.org are


