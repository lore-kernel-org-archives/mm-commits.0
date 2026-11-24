Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795540976;
	b=yWy5RNMTuP/TGH1CWjomV2D0moLewwGlzoWpC1JrrmDUKCh8yefaFRI16OQSSMwsZ63W
	 3HqVeAssBeN6sOmM1OZ2lVl39F5j3hovJGyk6m+DYvG0/bnng22TBvHNfOgVC4H/YyGQr
	 DTyXuVvaq0PLgPbsLTGl6oBIh0hL1Yx47vsOKmuToq+gI5Mph4H6Ww5BnUF9VNb5VTWJ/
	 BiZgnbMkPUiw4qBxPqVuNeGOXPGjriZVjo+LiINFV1n/mx+u+RivJmQjEpaPAEK1M5jkq
	 J11YAm+DDjhrUVes6A4sQpX6CWPXa0CbFHEK/QEBpFv4+ANzLU0c0ZsgR3wpv+RLkFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795540976;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=d96vwytp+p6QG4C/8YK7eLcd7KjGGxwUIzr5D7a9qYw=;
	b=2UxR2WJ34Ffp3tIHu49fhLBSa9k7Mm8QzSbMi+mfkZdznSoviuDoagqs8KDKnhWF146D
	 T0VDlDAJDbftWs09/uO4jmHLt8l+Ol8/iFdBOm4WCMTlNGTxYVqPZYpR5ervFRFXMC/HT
	 YeM36mHFJq6MD4vc8HXGp+AxkB6TurnFkaSITp1COzXvb1XwwgJasoyJiRrWPjkE05wnF
	 kFcS5Wvsvd/CViMHJ0RhObDkluMFkTxPIkQpLFFQ6eMozsQ1YEHJG0V4qf6PNwMIBLSLn
	 d2hTO9BP9lzpOW/XDWMvkOLnTpyLmgpSKYFuwLP+FYilhQ0IvylZuSRW/cCTrXQyPOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RjNoxHCt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439A1606A321
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RjNoxHCt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D351F000C0;
	Tue, 24 Nov 2026 17:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795540975;
	bh=d96vwytp+p6QG4C/8YK7eLcd7KjGGxwUIzr5D7a9qYw=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=RjNoxHCtqhyNUkkMb3Ohv3GMSUIcQwHPjlJZfsSPUbVQzrzSIKdFjfbBmzojfPvi6
	 ZHUfjkRecLx124q5n+NMJDcilVuy0NVRoKAhWoBDdOtwrH91RyUXF9yBWAt94d4iG2
	 SXC2r5NsJDWM37a6U5tH1Jn6lOPjsfq0ETLWo0yU=
Date: Tue, 24 Nov 2026 09:22:55 -0800
To: mm-commits@vger.kernel.org,lianux.mm@gmail.com,jm5905938@gmail.com,
	sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124153636.91854-2-sj@kernel.org>
References: <20261124153636.91854-2-sj@kernel.org>
Subject: + mm-damon-api-introduce-struct-damon_report.patch added to mm-new branch
Message-Id: <20261124172255.B4D351F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/api: introduce struct damon_report
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-api-introduce-struct-damon_report.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-api-introduce-struct-damon_report.patch

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
Subject: mm/damon/api: introduce struct damon_report
Date: Tue, 24 Nov 2026 07:36:07 -0800

Patch series "mm/damon: let users report their data attribute findings",
v2.

TL;DR
=====

Build a system for letting DAMON-external entities report their data
attribute findings to DAMON.  Let users report their data attribute
findings to DAMON using the report system.

When DAMON Extension Becomes Challenging
========================================

DAMON's probe based data attributes monitoring system allows flexible
extension of it for new types of information.  Such extensions are not
always easy, though.  That's because DAMON is collecting the information
on its own worker threads, kdamonds.  If the new information to extend
for is not already stored in a data structure that kdamonds can read,
the extension becomes difficult.

For example, extending DAMON for hugepage size of the given memory was
straightforward.  kdamonds can read that from folios.  Extending DAMON
for accessors or writes-only accesses is challenging because there is no
existing easy way to get that information from arbitrary threads like
kdamonds.

Extending DAMON for information that is not already available to
kdamonds requires two works.  Finding DAMON-external kernel components
that already have the information.  And modifying it to pass the
information to DAMON.  Finding and modifying the components inherently
need to be done for each of such extensions.  Building a universal way
to report the information to DAMON could make it much easier.

Modifying the component would be particularly challenging and even
controversial depending on each case.  Some components wouldn't want to
add a hacky change only for DAMON.  Having the universal report system
that is well maintained will be useful at convincing the component, too.

User Information
================

Users sometimes know some data attribute information more than what the
kernel can know.  They could know frequently accessed data.  They could
know that because they have access to the source code of the workload.
They could know that using non-DAMON kernel features.  They could know
that from some special tools and hardware.

DAMON is not only for monitoring but also operations.  DAMON finds
operation targets based on only its self monitoring results, though.
Letting users report their data attribute information allows more
flexible and effective control of the DAMON operations.  Users can make
DAMON to find operation targets based on both its self monitoring and
user-provided reports.

DAMON is not providing such ways to let users report their information,
though.

Report System and User Report Support
=====================================

DAMON lacks efficient DAMON-external information report system and user
report support.  Fill the gap.

Introduce a system to report information from kdamond-external entities
to DAMON.  Extend DAMON to monitor those reported information.  Build a
user interface for letting users report their findings.

Data Attribute Report System
============================

Introduce a system to report information from kdamond-external entities
to DAMON.  The report system let any kernel components in any context
including NMI context pass their data attribute finding to DAMON as a
report.

The system provides a data structure for such reports.  Using the report
data structure, a flexible data attribute information for a given memory
can be built.  The data structure also embeds a field for the type of
the report.  The report producer can specify what data attribute type
the report is providing, using the field.

The system exposes an API function, damon_submit_report(), for
submitting the report of the data type to DAMON.  The submit function
can be called from any context including NMI context.

DAMON Probe for Reports
=======================

Extend the DAMON probe filter to connect the report system with the
existing monitoring part of DAMON.  Introduce a new DAMON probe filter
type, report.  When the type is "report", it receives the report type
argument.  Filters of the type match to a given memory if a report of
the given type for the memory is made in the last sampling interval.
Update DAMON sysfs ABI for probe filters setup to support the new filter
type and the new argument for the report type.

User Report Support
===================

Let users report their findings.  Introduce a report type for the users
provided report.  Extend DAMON sysfs ABI to let users manually configure
and submit such reports one by one.  Users can specify for what memory
the report is made, with an arbitrary address range.

Using the new support, users can control DAMON using their own
information.  They can control DAMON using their information as only a
source, or an additional source to existing ones.  For example, they can
let DAMON do page table accessed-bit based access monitoring.  In
addition to that, if they know some hot data that might not be found by
the page table information, they can let DAMON know the hot data using
the report system.

Ongoing and Future Works
========================

This is a part of the "beyond page table accessed-bit DAMON extension"
project [1] milestone 2.  This patch series provides the initial and
essential part of the data attribute report system.

I will implement a cpu cycle sampling based extension based on the
report system that is implemented by this series.  It is for providing
accessor and type-aware access monitoring.  Using it, users will be able
to monitor access for given CPUs, tasks and types (read and/or write) of
accesses.

While doing that, the report system will also be advanced in a way that
can be used for reports that are not manually produced by the user but
by the kernel or hardware itself.  That will be the completion of the
second milestone of the parent project.  After that, people will be able
to build more extensions including AMD IBS-like hardware based
monitoring, using the advanced report system.

Patches Sequence
================

Introduce the data attribute report system with the first eleven patches
(patches 1-11).  Define the data structure for each report and expose
via DAMON core API, via patch 1.  Implement an internal data structure
for saving the reports, struct damon_report, via patch 2.  Introduce
another DAMON core API function for submitting each report,
damon_submit_report(), via patch 3.  Implement reports/producers/
sysfs directory next to the kdamonds/ directory, for controlling report
producers, via patches 4-8.  Update the design, the usage and the ABI
documents for the report system, with patches 9-11.

Extend the DAMON probe filter for the reports, with the following eight
patches (patches 12-19).  Introduce a new filter type, REPORT_MADE,
which matches if a report for the probing memory is made in last
sampling interval, via patch 12.  Implement and expose a DAMON core API
function, damon_report_exist(), that returns if a report of given
condition exist in the report queue, via patch 13.  Add support of the
new filter type in paddr operation set, via patch 14.  Implement sysfs
files for setting the new type of filter, via patches 15 and 16.  Update
the design, the usage and the ABI documents for the new filter type and
its user interface, via patches 17-19.

Finally, implement user report support with the subsequent eight patches
(patches 20-27).  Introduce a new report type DAMON core API,
USER_REPORT, via patch 20.  Add a user keyword for the new report type
to sysfs files, via patch 21.  Implement sysfs files for manually
generating and submitting user reports, via patches 22 and 23.  Add a
simple selftest for new sysfs files, via patch 24.  Update the design,
the usage and the ABI documents for the new report type and its user
interface, via patches 25-27.

References
==========

[1] Beyond page table accessed bits DAMON extension roadmap:
    https://lore.kernel.org/20260525225208.1179-1-sj@kernel.org/

Tests
=====

Confirmed the user report is working like below.

Submit report for [5 GiB, 6 GiB) address range for every 5 milliseconds.

    # cd /sys/kernel/mm/damon/admin/reports/producers/
    # echo 1 > nr_producers
    # echo $((5*1024*1024)) > 0/addr_start
    # echo $((6*1024*1024)) > 0/addr_end
    # echo on > 0/producer_state
    # while true; do echo submit > producer_state ; sleep 0.005; done

On another terminal session, start DAMON in the attribute only
monitoring mode, with user_report report_made probe filter type, using
DAMON user-space tool, damo [1].

    $ sudo ./damo start --probe \
            --probe_filter allow report_made user_report \
            --probe_weight 1

Show the user report for the [5 GiB, 6 GiB) address range is detected:

    $ sudo ./damo report attrs --sort_regions_by address
    heatmap:
    00000000000000000000000000000000000000000000000000069999999995111111100000000000
    # min/max temperatures: -790,000,000, 80,001,900, column size: 99.800
    MiB
    probe allow report_made user_report (weight: 1)
    intervals: sample 5 ms aggr 100 ms (max probe hits 20)
    #   size         address       age           probe_hits
    0   4.678 GiB    4.000 KiB     7.900 s       0
    1   329.582 MiB  4.678 GiB     7.400 s       0
    2   1024.000 MiB  5.000 GiB     800 ms        19
    3   792.809 MiB  6.000 GiB     6.900 s       0
    4   1.023 GiB    6.774 GiB     7.900 s       0
    memory bw estimate: 0 B per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

the region of index 2 is the region for the [5 GiB, 6 GiB) address
range.  DAMON received the user report for nearly all sampling
intervals, and therefore shows its probe_hits as 19.

Stop user report submissions using Ctrl-C on the report submit terminal
session. Show DAMON monitoring results showing no more reports are
submitted.

    $ sudo ./damo report attrs --sort_regions_by address
    heatmap:
    00000000000000000000000000000000000000000000000366666668999999822222221000000000
    # min/max temperatures: -1,740,000,000, -740,000,000, column size:
    99.800 MiB
    probe allow report_made user_report (weight: 1)
    intervals: sample 5 ms aggr 100 ms (max probe hits 20)
    #   size         address       age           probe_hits
    0   1.551 GiB    4.000 KiB     17.400 s      0
    1   1.536 GiB    1.551 GiB     17.300 s      0
    2   788.715 MiB  3.087 GiB     17.200 s      0
    3   797.793 MiB  3.857 GiB     16.800 s      0
    4   764.137 MiB  4.636 GiB     10.300 s      0
    5   768.867 MiB  5.382 GiB     7.400 s       0
    6   774.043 MiB  6.133 GiB     14.500 s      0
    7   797.250 MiB  6.889 GiB     17 s          0
    8   132.488 MiB  7.667 GiB     17.400 s      0
    memory bw estimate: 0 B per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

No more probe_hits for [5 GiB, 6 GiB) address range is shown, since the
user report is stopped..


This patch (of 27):

Define a struct for data attribute report.  The struct provides public
fields for the type and the memory address range.  The type field
represents the type of the report itself.  The address range is for the
memory of the reporting data.  Data attribute producers can format their
report using those fields.

It also has a private field representing when the report is submitted.

Link: https://lore.kernel.org/20261124153636.91854-1-sj@kernel.org
Link: https://patch.msgid.link/20261124153636.91854-2-sj@kernel.org
Link: https://github.com/damonitor/damo [1]
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>

 include/linux/damon.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/include/linux/damon.h~mm-damon-api-introduce-struct-damon_report
+++ a/include/linux/damon.h
@@ -758,6 +758,27 @@ struct damon_intervals_goal {
 };
 
 /**
+ * enum damon_report_type - Type of &struct damon_report.
+ */
+enum damon_report_type {
+	NR_DAMON_REPORT_TYPES,
+};
+
+/**
+ * struct damon_report - Data attribute report information.
+ *
+ * @type:	Type of the report.
+ * @addr_range:	The address range of the memory to report for.
+ */
+struct damon_report {
+	enum damon_report_type type;
+	struct damon_addr_range addr_range;
+/* private: */
+	/* when this report is generated */
+	unsigned long jiffies;
+};
+
+/**
  * enum damon_prep_action - DAMON probing preparation action.
  *
  * @DAMON_PREP_SET_PGIDLE:	Set the probing memory as idle page.
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

