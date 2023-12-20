Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7D5225DA
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gwbz5tFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B877CC433C7;
	Wed, 20 Dec 2023 22:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703112566;
	bh=oeq6uKwd/JwYkhuX6kgUy3MoZwqSfzyUldRsSDLcJdc=;
	h=Date:To:From:Subject:From;
	b=gwbz5tFW2QkZ4Y7M3wqcIpw7ja7eTE2nIGFR9AnucB+mryKTcNODlbolmnykG/gm6
	 s5YmQjSDjlhcB2J/klBxidMtCieF05nViGHW8HtuCt16XrwVz3T83qRSZcT5dsPLm2
	 zqC3Fkh98prqH3drVKPD3OrbDQqIj76ZB8HD7h+E=
Date: Wed, 20 Dec 2023 14:49:26 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-place-execution-model-and-data-structures-at-the-beginning.patch removed from -mm tree
Message-Id: <20231220224926.B877CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: place execution model and data structures at the beginning
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-place-execution-model-and-data-structures-at-the-beginning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: place execution model and data structures at the beginning
Date: Wed, 13 Dec 2023 19:03:35 +0000

The execution model and data structures section at the end of the design
document is briefly explaining how DAMON works overall.  Knowing that
first may help better drawing the overall picture.  It may also help
better understanding following detailed sections.  Move it to the
beginning of the document.

Link: https://lkml.kernel.org/r/20231213190338.54146-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-place-execution-model-and-data-structures-at-the-beginning
+++ a/Documentation/mm/damon/design.rst
@@ -5,6 +5,18 @@ Design
 ======
 
 
+.. _damon_design_execution_model_and_data_structures:
+
+Execution Model and Data Structures
+===================================
+
+The monitoring-related information including the monitoring request
+specification and DAMON-based operation schemes are stored in a data structure
+called DAMON ``context``.  DAMON executes each context with a kernel thread
+called ``kdamond``.  Multiple kdamonds could run in parallel, for different
+types of monitoring.
+
+
 Overall Architecture
 ====================
 
@@ -490,15 +502,3 @@ modules for proactive reclamation and LR
 more detail, please read the usage documents for those
 (:doc:`/admin-guide/mm/damon/reclaim` and
 :doc:`/admin-guide/mm/damon/lru_sort`).
-
-
-.. _damon_design_execution_model_and_data_structures:
-
-Execution Model and Data Structures
-===================================
-
-The monitoring-related information including the monitoring request
-specification and DAMON-based operation schemes are stored in a data structure
-called DAMON ``context``.  DAMON executes each context with a kernel thread
-called ``kdamond``.  Multiple kdamonds could run in parallel, for different
-types of monitoring.
_

Patches currently in -mm which might be from sj@kernel.org are


