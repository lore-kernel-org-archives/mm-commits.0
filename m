From: akpm@linux-foundation.org
Subject: + checkpatch-enforce-sane-perl-version.patch added to -mm tree
Date: Mon, 29 Jul 2013 15:53:32 -0700
Message-ID: <51f6f26c.E8xXo6vDrfNnhOwF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60679 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706Ab3G2Wxd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 18:53:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, apw@shadowen.org, dave.hansen@linux.intel.com

Subject: + checkpatch-enforce-sane-perl-version.patch added to -mm tree
To: dave.hansen@linux.intel.com,apw@shadowen.org,joe@perches.com
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 15:53:32 -0700


The patch titled
     Subject: checkpatch: enforce sane perl version
has been added to the -mm tree.  Its filename is
     checkpatch-enforce-sane-perl-version.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-enforce-sane-perl-version.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-enforce-sane-perl-version.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: checkpatch: enforce sane perl version

I got a bug report from a couple of users who said checkpatch.pl was
broken for them.  It was erroring out on fairly random lines most commonly
with messages like:

	Nested quantifiers in regex; marked by <--HERE in m/(\((?:[^\(\)]++ <-- HERE |(?-1))*\))/ at ./checkpatch.pl line 340.

The bug reporter was running a version of perl 5.8 which was end-of-lifed
in 2008: http://www.cpan.org/src/.  Versions of perl this old are at
_best_ quite untested.  At worst, they are crusty and known to be
completely broken.

If folks have a system _that_ old, then we should have mercy on them and
give them a half-decent error message rather than fail with nutty error
messages.

This patch enforces that checkpatch.pl is run with perl 5.10, which was
end-of-lifed in 2009.  The new --ignore-perl-version command-line switch
will let folks override this if they want.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-enforce-sane-perl-version scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-enforce-sane-perl-version
+++ a/scripts/checkpatch.pl
@@ -37,6 +37,8 @@ my @ignore = ();
 my $help = 0;
 my $configuration_file = ".checkpatch.conf";
 my $max_line_length = 80;
+my $ignore_perl_version = 0;
+my $minimum_perl_version = 5.10.0;
 
 sub help {
 	my ($exitcode) = @_;
@@ -71,6 +73,8 @@ Options:
                              "<inputfile>.EXPERIMENTAL-checkpatch-fixes"
                              with potential errors corrected to the preferred
                              checkpatch style
+  --ignore-perl-version      override checking of perl version.  expect
+                             runtime errors.
   -h, --help, --version      display this help and exit
 
 When FILE is - read standard input.
@@ -123,6 +127,7 @@ GetOptions(
 	'mailback!'	=> \$mailback,
 	'summary-file!'	=> \$summary_file,
 	'fix!'		=> \$fix,
+	'ignore-perl-version!' => \$ignore_perl_version,
 	'debug=s'	=> \%debug,
 	'test-only=s'	=> \$tst_only,
 	'h|help'	=> \$help,
@@ -133,6 +138,13 @@ help(0) if ($help);
 
 my $exit = 0;
 
+if ($^V && $^V lt $minimum_perl_version) {
+	printf "$P: requires at least perl version %vd\n", $minimum_perl_version;
+	if (!$ignore_perl_version) {
+		exit(1);
+	}
+}
+
 if ($#ARGV < 0) {
 	print "$P: no input files\n";
 	exit(1);
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

thp-mm-avoid-pageunevictable-on-active-inactive-lru-lists.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_shmem_file_read.patch
thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch
mm-vmstats-tlb-flush-counters.patch
mm-vmstats-track-tlb-flush-stats-on-up-too.patch
thp-mm-locking-tail-page-is-a-bug.patch
checkpatch-enforce-sane-perl-version.patch

