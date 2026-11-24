Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541007;
	b=5n9SkOjZ4PaSDyA7dZTVh0U9+oh5d0Pjy4qSnIeCgWYnNQNJgIcEHCX8njBZWBmp/tjG
	 R6vAOHqfXlzY1m4elS1f4gmaftlyP1L+h1J1uSCb2hb+dkbBGWsvEMSB5AkPWF3jTwU3x
	 rCb/EZWvVBMrqlpOQ3CLPYM6eKxzfD/rygcwNLikKCHoD5PXuBZpq5H432qEaJYUcSlWg
	 0artl5RH4yfS2nqpHND5eA7E9NwJpY3UykALUQCtEscZgEjg7C1Rvv6jrC6cFQ2E5XB0+
	 mIE3Taz4nFtTcDytygZwksEpm5zQzQHS9zepBjmcHpqoZfuzEVpJV6EWxMnjv91tOCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541007;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=Xzh5iHvWRj8EcWw98AMnxJRky22Jrc6FzXMt+IgWxUo=;
	b=Ju84bZa8NQL0qsM5jhfB8GtAFkhSPDX9RG+Vl9wGZLSlZO5OJ/7zP0xT17CaF8U+/cqe
	 gbd725HH4t9GcaPcRa9HQK1et8usTA6ib9Hoxg5+ZjXM5qy6P/gFSV2FuQIjzO6cgyFte
	 eJewLqdOP8k5XD4b2y1lXpMZJk2UaOwbZkfENQe+6mlwXlnQ6f/EsV1IQIyX6R2deLuM4
	 XCp8DwRNDM1FJnogEIM8p2fGWSaUlVrNfiUPiKjEj1Cw7Hbky/VEvGcygrrnZvrS5mr9x
	 IAMW6TXTIHM1AAitXM5fNWCzMQx46WXRIUJtI90NZj3+G8k6wP73KsQ6+qdi3y6EDnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yktIUgey;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F6C606A323
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yktIUgey
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A091F000D1;
	Tue, 24 Nov 2026 17:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795541006;
	bh=Xzh5iHvWRj8EcWw98AMnxJRky22Jrc6FzXMt+IgWxUo=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=yktIUgeywRxd/N1hGRLPlcpzH2Sg0B6BcRbxyKTPph5uwGJiQId1SfVRetA92ciqx
	 QnwxVV7Wl5KHStFC+pUWpTYODUGEyg8bu2bM5Ay9hIsjW5BYP2drLVDlK/PNvuiNhi
	 4UFjPWUOQvd34Z5kPN4jjF7NBRc/hQWHmSq2mMjQ=
Date: Tue, 24 Nov 2026 09:23:26 -0800
To: mm-commits@vger.kernel.org,lianux.mm@gmail.com,jm5905938@gmail.com,
	sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124153636.91854-13-sj@kernel.org>
References: <20261124153636.91854-13-sj@kernel.org>
Subject: + mm-damon-core-introduce-damon_filter_type_report_made.patch added to mm-new branch
Message-Id: <20261124172326.C0A091F000D1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/core: introduce DAMON_FILTER_TYPE_REPORT_MADE
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-introduce-damon_filter_type_report_made.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-introduce-damon_filter_type_report_made.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: introduce DAMON_FILTER_TYPE_REPORT_MADE
Date: Tue, 24 Nov 2026 07:36:18 -0800

Extend DAMON probe filter for the existence of data attribute reports
for the probing memory.  Define a new filter type, REPORT_MADE, for the
purpose.  Add a union argument for specifying the type of the reports
for the filter.  Update the new argument for the new type when new
filter parameters of the type are committed.

Link: https://patch.msgid.link/20261124153636.91854-13-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>

 include/linux/damon.h |    5 +++++
 mm/damon/core.c       |    6 ++++++
 2 files changed, 11 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-introduce-damon_filter_type_report_made
+++ a/include/linux/damon.h
@@ -808,6 +808,7 @@ struct damon_prep {
  * @DAMON_FILTER_TYPE_PGIDLE_SET:	Pgidle is set.
  * @DAMON_FILTER_TYPE_HUGEPAGE_SIZE:	Page is part of a hugepage.
  * @DAMON_FILTER_TYPE_ACTIVE:		LRU-active pages.
+ * @DAMON_FILTER_TYPE_REPORT_MADE:	Report is submitted.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
@@ -816,6 +817,7 @@ enum damon_filter_type {
 	DAMON_FILTER_TYPE_PGIDLE_SET,
 	DAMON_FILTER_TYPE_HUGEPAGE_SIZE,
 	DAMON_FILTER_TYPE_ACTIVE,
+	DAMON_FILTER_TYPE_REPORT_MADE,
 };
 
 /**
@@ -827,6 +829,8 @@ enum damon_filter_type {
  * @memcg_id:	Memcg id of the question if @type is DAMON_FILTER_MEMCG.
  * @range_min:	Minimum value of range arguments.
  * @range_max:	Maximum value of range arguments.
+ * @report_type:	Type of the report, if @type is
+ *			DAMON_FILTER_TYPE_REPORT_MADE..
  */
 struct damon_filter {
 	enum damon_filter_type type;
@@ -838,6 +842,7 @@ struct damon_filter {
 			unsigned long range_min;
 			unsigned long range_max;
 		};
+		enum damon_report_type report_type;
 	};
 /* private: */
 	/* Siblings list. */
--- a/mm/damon/core.c~mm-damon-core-introduce-damon_filter_type_report_made
+++ a/mm/damon/core.c
@@ -1837,6 +1837,9 @@ static int damon_commit_filter(struct da
 		dst->range_min = src->range_min;
 		dst->range_max = src->range_max;
 		break;
+	case DAMON_FILTER_TYPE_REPORT_MADE:
+		dst->report_type = src->report_type;
+		break;
 	default:
 		break;
 	}
@@ -1880,6 +1883,9 @@ static int damon_commit_filters(struct d
 			new_filter->range_min = src_filter->range_min;
 			new_filter->range_max = src_filter->range_max;
 			break;
+		case DAMON_FILTER_TYPE_REPORT_MADE:
+			new_filter->report_type = src_filter->report_type;
+			break;
 		default:
 			break;
 		}
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-copy-only-installed-probe-in-damon_split_region_at.patch
mm-damon-core-add-damos_filter_type_age_ms.patch
mm-damon-sysfs-schemes-support-damos_filter_type_age_ms.patch
docs-mm-damon-design-update-for-age_ms-damos-core-filter-type.patch
docs-admin-guide-mm-damon-usage-update-for-age_ms-damos-core-filter.patch
mm-damon-api-define-damon_filter_type_active.patch
mm-damon-ops-common-implement-damon_filter_type_active-operation.patch
mm-damon-sysfs-support-lru-activeness-based-damon-filter-setup.patch
docs-mm-damon-design-update-for-damon_filter_type_active.patch
maintainers-change-damon-scm-tree-to-mm-damongit.patch
docs-mm-damon-maintainer-profile-use-damongit-for-patch-baselines.patch
docs-mm-damon-maintainer-profile-drop-scm-trees-section.patch
docs-mm-damon-maintainer-profile-update-key-cycle-dates-for-damongit.patch
mm-damon-api-introduce-struct-damon_report.patch
mm-damon-core-implement-data-attribute-report-queue.patch
mm-damon-core-introduce-damon_submit_report.patch
mm-damon-sysfs-add-admin-reports-directory.patch
mm-damon-sysfs-add-reports-producers-directory.patch
mm-damon-sysfs-add-producers-nr_producers-file.patch
mm-damon-sysfs-implement-report-producer-directory.patch
mm-damon-sysfs-implement-report-producer-type-and-state-files.patch
docs-mm-damon-design-update-for-report-system.patch
docs-admin-guide-mm-damon-usage-update-for-report-producer-sysfs.patch
docs-abi-damon-update-for-report-producer-sysfs-files.patch
mm-damon-core-introduce-damon_filter_type_report_made.patch
mm-damon-core-introduce-damon_report_exist.patch
mm-damon-paddr-support-report_made-type-probe-filter.patch
mm-damon-sysfs-add-filter_report_type-file-under-probe-filter-directory.patch
mm-damon-sysfs-support-report_made-type-probe-filter-setup.patch
docs-mm-damon-design-update-for-report_made-probe-filter-type.patch
docs-admin-guide-mm-damon-usage-update-for-report_made-probe-filter.patch
docs-abi-damon-update-for-report_made-probe-filter.patch
mm-damon-api-introduce-user_report-report-type.patch
mm-damon-sysfs-add-user_report-support-for-report-type-input.patch
mm-damon-sysfs-implement-report-producer-addr_startend-files.patch
mm-damon-sysfs-implement-submit-command-for-report-producer.patch
selftests-damon-sysfssh-add-basic-tests-for-admin-reports.patch
docs-mm-damon-design-update-for-user-report-support.patch
docs-admin-guide-mm-damon-usage-update-for-user_report-report-support.patch
docs-abi-damon-update-for-user_report-report-support.patch

