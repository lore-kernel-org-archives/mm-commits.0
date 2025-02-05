Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DEC20E316
	for <mm-commits@vger.kernel.org>; Wed,  5 Feb 2025 03:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738725027; cv=none; b=ppugpJhw80yifSvoXDPoCqDgzvlzTH5gNBRzMjLZEMmNUyOqQMPPbslbDBYHt1yzmWWnwvWCKKZe28/lZAaoIpqWFRNS+eD5kTz0lmT0FxuIkzKvbj4olnCgaP5yV61BgptKEmmQpgcRcf+mB7VWRHYZUnMyoC0uT+SjfXQ987Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738725027; c=relaxed/simple;
	bh=d4/vuDgVjph2yPefbVIZDBcjte/8bnVH6ustZR2tRdY=;
	h=Date:To:From:Subject:Message-Id; b=MDINAEoJE/7G5peJxWxn+0MccTwdVK+ybL8DgiDhH6htdsg/WOxSD2csxJzP5NueX3MnX9doIrKPGYUGFO7vZnW1K+a7seWYWojg0syWYfQccu9OCppXTMCYRGqkkhuwnDdRiHM1z/Mm+QvBr33krcpjpnElNK3CKuKNAEi5iTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2DxJ6cta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2DxJ6cta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFC4C4CEDF;
	Wed,  5 Feb 2025 03:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738725026;
	bh=d4/vuDgVjph2yPefbVIZDBcjte/8bnVH6ustZR2tRdY=;
	h=Date:To:From:Subject:From;
	b=2DxJ6ctaK69AMwhf0o2nliR1axNZ96l3VRFbMKYrYKgFscMPNcZ6AnllEOLUIlp7A
	 tEAl2VvVSQBWRbiZ09olQxxq3BExbIcgMTKZWzW9sWPBoP25PaY3I/b+cilm0cGl6k
	 ggstjLsyPdIGCM2hAO59wLLlNyOcEWUM9bNfvL1s=
Date: Tue, 04 Feb 2025 19:10:25 -0800
To: mm-commits@vger.kernel.org,tytso@mit.edu,lorenzo.stoakes@oracle.com,linux@leemhuis.info,kees@kernel.org,joe@perches.com,bryan.odonoghue@linaro.org,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + get_maintainer-add-substatus-for-reporting-subsystem-status.patch added to mm-nonmm-unstable branch
Message-Id: <20250205031026.8AFC4C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: get_maintainer: add --substatus for reporting subsystem status
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     get_maintainer-add-substatus-for-reporting-subsystem-status.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/get_maintainer-add-substatus-for-reporting-subsystem-status.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: get_maintainer: add --substatus for reporting subsystem status
Date: Mon, 03 Feb 2025 12:13:16 +0100

Patch series "get_maintainer: report subsystem status separately", v2.

The subsystem status (S: field) can inform a patch submitter if the
subsystem is well maintained or e.g.  maintainers are missing.  In
get_maintainer, it is currently reported with --role(stats) by adjusting
the maintainer role for any status different from Maintained.  This has
two downsides:

- if a subsystem has only reviewers or mailing lists and no maintainers,
  the status is not reported. For example Orphan subsystems typically
  have no maintainers so there's nobody to report as orphan minder.

- the Supported status means that someone is paid for maintaining, but
  it is reported as "supporter" for all the maintainers, which can be
  incorrect (only some of them may be paid). People (including myself)
  have been also confused about what "supporter" means.

The second point has been brought up in 2022 and the discussion in the end
resulted in adjusting documentation only [1].  I however agree with Ted's
points that it's misleading to take the subsystem status and apply it to
all maintainers [2].

The attempt to modify get_maintainer output was retracted after Joe
objected that the status becomes not reported at all [3].  This series
addresses that concern by reporting the status (unless it's the most
common Maintained one) on separate lines that follow the reported emails,
using a new --substatus parameter.  Care is taken to reduce the noise to
minimum by not reporting the most common Maintained status, by detault
require no opt-in that would need the users to discover the new parameter,
and at the same time not to break existing git --cc-cmd usage.

[1] https://lore.kernel.org/all/20221006162413.858527-1-bryan.odonoghue@linaro.org/
[2] https://lore.kernel.org/all/Yzen4X1Na0MKXHs9@mit.edu/
[3] https://lore.kernel.org/all/30776fe75061951777da8fa6618ae89bea7a8ce4.camel@perches.com/


This patch (of 2):

The subsystem status is currently reported with --role(stats) by adjusting
the maintainer role for any status different from Maintained.  This has
two downsides:

- if a subsystem has only reviewers or mailing lists and no maintainers,
  the status is not reported (i.e. typically, Orphan subsystems have no
  maintainers)

- the Supported status means that someone is paid for maintaining, but
  it is reported as "supporter" for all the maintainers, which can be
  incorrect. People have been also confused about what "supporter"
  means.

This patch introduces a new --substatus option and functionality aimed to
report the subsystem status separately, without adjusting the reported
maintainer role.  After the e-mails are output, the status of subsystems
will follow, for example:

...
linux-kernel@vger.kernel.org (open list:LIBRARY CODE)
LIBRARY CODE status: Supported

In order to allow replacing the role rewriting seamlessly, the new
option works as follows:

- it is automatically enabled when --email and --role are enabled
  (the defaults include --email and --rolestats which implies --role)

- usages with --norolestats e.g. for git's --cc-cmd will thus need no
  adjustments

- the most common Maintained status is not reported at all, to reduce
  unnecessary noise

- THE REST catch-all section (contains lkml) status is not reported

- the existing --subsystem and --status options are unaffected so their
  users will need no adjustments

Link: https://lkml.kernel.org/r/20250203-b4-get_maintainer-v2-0-83ba008b491f@suse.cz
Link: https://lkml.kernel.org/r/20250203-b4-get_maintainer-v2-1-83ba008b491f@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc: Joe Perches <joe@perches.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Thorsten Leemhuis <linux@leemhuis.info>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

--- a/scripts/get_maintainer.pl~get_maintainer-add-substatus-for-reporting-subsystem-status
+++ a/scripts/get_maintainer.pl
@@ -50,6 +50,7 @@ my $output_multiline = 1;
 my $output_separator = ", ";
 my $output_roles = 0;
 my $output_rolestats = 1;
+my $output_substatus = undef;
 my $output_section_maxlen = 50;
 my $scm = 0;
 my $tree = 1;
@@ -269,6 +270,7 @@ if (!GetOptions(
 		'separator=s' => \$output_separator,
 		'subsystem!' => \$subsystem,
 		'status!' => \$status,
+		'substatus!' => \$output_substatus,
 		'scm!' => \$scm,
 		'tree!' => \$tree,
 		'web!' => \$web,
@@ -314,6 +316,10 @@ $output_multiline = 0 if ($output_separa
 $output_rolestats = 1 if ($interactive);
 $output_roles = 1 if ($output_rolestats);
 
+if (!defined $output_substatus) {
+    $output_substatus = $email && $output_roles;
+}
+
 if ($sections || $letters ne "") {
     $sections = 1;
     $email = 0;
@@ -637,6 +643,7 @@ my @web = ();
 my @bug = ();
 my @subsystem = ();
 my @status = ();
+my @substatus = ();
 my %deduplicate_name_hash = ();
 my %deduplicate_address_hash = ();
 
@@ -651,6 +658,11 @@ if ($scm) {
     output(@scm);
 }
 
+if ($output_substatus) {
+    @substatus = uniq(@substatus);
+    output(@substatus);
+}
+
 if ($status) {
     @status = uniq(@status);
     output(@status);
@@ -859,6 +871,7 @@ sub get_maintainers {
     @bug = ();
     @subsystem = ();
     @status = ();
+    @substatus = ();
     %deduplicate_name_hash = ();
     %deduplicate_address_hash = ();
     if ($email_git_all_signature_types) {
@@ -1073,6 +1086,7 @@ MAINTAINER field selection options:
     --remove-duplicates => minimize duplicate email names/addresses
     --roles => show roles (status:subsystem, git-signer, list, etc...)
     --rolestats => show roles and statistics (commits/total_commits, %)
+    --substatus => show subsystem status if not Maintained (default: match --roles)"
     --file-emails => add email addresses found in -f file (default: 0 (off))
     --fixes => for patches, add signatures of commits with 'Fixes: <commit>' (default: 1 (on))
   --scm => print SCM tree(s) if any
@@ -1335,7 +1349,9 @@ sub add_categories {
     my $start = find_starting_index($index);
     my $end = find_ending_index($index);
 
-    push(@subsystem, $typevalue[$start]);
+    my $subsystem = $typevalue[$start];
+    push(@subsystem, $subsystem);
+    my $status = "Unknown";
 
     for ($i = $start + 1; $i < $end; $i++) {
 	my $tv = $typevalue[$i];
@@ -1386,8 +1402,8 @@ sub add_categories {
 		}
 	    } elsif ($ptype eq "R") {
 		if ($email_reviewer) {
-		    my $subsystem = get_subsystem_name($i);
-		    push_email_addresses($pvalue, "reviewer:$subsystem" . $suffix);
+		    my $subs = get_subsystem_name($i);
+		    push_email_addresses($pvalue, "reviewer:$subs" . $suffix);
 		}
 	    } elsif ($ptype eq "T") {
 		push(@scm, $pvalue . $suffix);
@@ -1397,9 +1413,14 @@ sub add_categories {
 		push(@bug, $pvalue . $suffix);
 	    } elsif ($ptype eq "S") {
 		push(@status, $pvalue . $suffix);
+		$status = $pvalue;
 	    }
 	}
     }
+
+    if ($subsystem ne "THE REST" and $status ne "Maintained") {
+	push(@substatus, $subsystem . " status: " . $status . $suffix)
+    }
 }
 
 sub email_inuse {
@@ -1903,6 +1924,7 @@ EOT
 		$done = 1;
 		$output_rolestats = 0;
 		$output_roles = 0;
+		$output_substatus = 0;
 		last;
 	    } elsif ($nr =~ /^\d+$/ && $nr > 0 && $nr <= $count) {
 		$selected{$nr - 1} = !$selected{$nr - 1};
_

Patches currently in -mm which might be from vbabka@suse.cz are

get_maintainer-add-substatus-for-reporting-subsystem-status.patch
get_maintainer-stop-reporting-subsystem-status-as-maintainer-role.patch

