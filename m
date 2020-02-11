From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?selftests-vm-run=5Fvmtests-invoke-gup=5Fbenchmark-with-basic?=
 =?US-ASCII?Q?-foll=5Fpin-coverage.patch?= added to -mm tree
Date: Mon, 10 Feb 2020 21:50:56 -0800
Message-ID: <20200211055056.9Cs-5z6Ln%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726942AbgBKFu6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Feb 2020 00:50:58 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org, ira.weiny@intel.com, jack@suse.cz, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, shuah@kernel.org, vbabka@suse.cz, viro@zeniv.linux.org.uk, willy@infradead.org


The patch titled
     Subject: selftests/vm: run_vmtests: invoke gup_benchmark with basic FO=
LL_PIN coverage
has been added to the -mm tree.  Its filename is
     selftests-vm-run_vmtests-invoke-gup_benchmark-with-basic-foll_pin-cove=
rage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-run_vmtests-invok=
e-gup_benchmark-with-basic-foll_pin-coverage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-run_vmtests-invok=
e-gup_benchmark-with-basic-foll_pin-coverage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm: run_vmtests: invoke gup_benchmark with basic FOLL_PI=
N coverage

It's good to have basic unit test coverage of the new FOLL_PIN behavior.=20
Fortunately, the gup_benchmark unit test is extremely fast (a few
milliseconds), so adding it the the run_vmtests suite is going to cause no
noticeable change in running time.

So, add two new invocations to run_vmtests:

1) Run gup_benchmark with normal get_user_pages().

2) Run gup_benchmark with pin_user_pages().  This is much like the
   first call, except that it sets FOLL_PIN.

Running these two in quick succession also provide a visual comparison of
the running times, which is convenient.

The new invocations are fairly early in the run_vmtests script, because
with test suites, it's usually preferable to put the shorter, faster tests
first, all other things being equal.

Link: http://lkml.kernel.org/r/20200211001536.1027652-11-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/run_vmtests |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/tools/testing/selftests/vm/run_vmtests~selftests-vm-run_vmtests-invok=
e-gup_benchmark-with-basic-foll_pin-coverage
+++ a/tools/testing/selftests/vm/run_vmtests
@@ -123,6 +123,28 @@ else
 	echo "[PASS]"
 fi
=20
+echo "--------------------------------------------"
+echo "running 'gup_benchmark -U' (normal/slow gup)"
+echo "--------------------------------------------"
+./gup_benchmark -U
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=3D1
+else
+	echo "[PASS]"
+fi
+
+echo "------------------------------------------"
+echo "running gup_benchmark -b (pin_user_pages)"
+echo "------------------------------------------"
+./gup_benchmark -b
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=3D1
+else
+	echo "[PASS]"
+fi
+
 echo "-------------------"
 echo "running userfaultfd"
 echo "-------------------"
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-split-get_user_pages_remote-into-two-routines.patch
mm-gup-pass-a-flags-arg-to-__gup_device_-functions.patch
mm-introduce-page_ref_sub_return.patch
mm-gup-pass-gup-flags-to-two-more-routines.patch
mm-gup-require-foll_get-for-get_user_pages_fast.patch
mm-gup-track-foll_pin-pages.patch
mm-gup-page-hpage_pinned_refcount-exact-pin-counts-for-huge-pages.patch
mm-gup-proc-vmstat-pin_user_pages-foll_pin-reporting.patch
mm-gup_benchmark-support-pin_user_pages-and-related-calls.patch
selftests-vm-run_vmtests-invoke-gup_benchmark-with-basic-foll_pin-coverage.=
patch
mm-dump_page-additional-diagnostics-for-huge-pinned-pages.patch
