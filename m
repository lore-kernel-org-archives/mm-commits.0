From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?get=5Fmaintainer-fix-unexpected-behavior-for-path-to-file-?=
 =?US-ASCII?Q?double-slashes.patch?= added to -mm tree
Date: Fri, 15 May 2020 12:25:25 -0700
Message-ID: <20200515192525.1hAmBec4m%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgEOTZ1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 May 2020 15:25:27 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emil.l.velikov@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: fix unexpected behavior for path/to//file (double slashes)
has been added to the -mm tree.  Its filename is
     get_maintainer-fix-unexpected-behavior-for-path-to-file-double-slashes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/get_maintainer-fix-unexpected-behavior-for-path-to-file-double-slashes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/get_maintainer-fix-unexpected-behavior-for-path-to-file-double-slashes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: get_maintainer: fix unexpected behavior for path/to//file (double slashes)

get_maintainer behaves differently if there is a double sequential forward
slash in a filename because the total number of slashes in a filename is
used to match MAINTAINERS file patterns.

For example:

# (with double slash)
$ ./scripts/get_maintainer.pl -f drivers/gpu/drm//lima
David Airlie <airlied@linux.ie> (maintainer:DRM DRIVERS)
Daniel Vetter <daniel@ffwll.ch> (maintainer:DRM DRIVERS,commit_signer:3/42=7%)
Qiang Yu <yuq825@gmail.com> (commit_signer:36/42=86%,authored:24/42=57%)
Vasily Khoruzhick <anarsoul@gmail.com> (commit_signer:26/42=62%)
Krzysztof Kozlowski <krzk@kernel.org> (commit_signer:5/42=12%,authored:5/42=12%)
Emil Velikov <emil.velikov@collabora.com> (commit_signer:4/42=10%)
dri-devel@lists.freedesktop.org (open list:DRM DRIVERS)
linux-kernel@vger.kernel.org (open list)

# (without double slash)
$ ./scripts/get_maintainer.pl -f drivers/gpu/drm/lima
Qiang Yu <yuq825@gmail.com> (maintainer:DRM DRIVERS FOR LIMA)
David Airlie <airlied@linux.ie> (maintainer:DRM DRIVERS)
Daniel Vetter <daniel@ffwll.ch> (maintainer:DRM DRIVERS)
dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR LIMA)
lima@lists.freedesktop.org (moderated list:DRM DRIVERS FOR LIMA)
linux-kernel@vger.kernel.org (open list)

So reduce consecutive double slashes to a single slash
by using File::Spec->canonpath().

from: https://perldoc.perl.org/File/Spec/Unix.html

canonpath()

No physical check on the filesystem, but a logical cleanup of a path.  On
UNIX eliminates successive slashes and successive "/.".

Link: http://lkml.kernel.org/r/9a18b611813bb409fef15bc8927adab79eb9be43.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Emil Velikov <emil.l.velikov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/get_maintainer.pl~get_maintainer-fix-unexpected-behavior-for-path-to-file-double-slashes
+++ a/scripts/get_maintainer.pl
@@ -19,6 +19,7 @@ my $V = '0.26';
 use Getopt::Long qw(:config no_auto_abbrev);
 use Cwd;
 use File::Find;
+use File::Spec::Functions;
 
 my $cur_path = fastgetcwd() . '/';
 my $lk_path = "./";
@@ -532,6 +533,7 @@ if (!@ARGV) {
 
 foreach my $file (@ARGV) {
     if ($file ne "&STDIN") {
+	$file = canonpath($file);
 	##if $file is a directory and it lacks a trailing slash, add one
 	if ((-d $file)) {
 	    $file =~ s@([^/])$@$1/@;
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch
get_maintainer-add-email-addresses-from-yaml-files.patch
get_maintainer-fix-unexpected-behavior-for-path-to-file-double-slashes.patch
percpu_ref-use-a-more-common-logging-style.patch
checkpatch-additional-maintainer-section-entry-ordering-checks.patch
checkpatch-look-for-c99-comments-in-ctx_locate_comment.patch
checkpatch-disallow-git-and-file-fix.patch
checkpatch-use-patch-subject-when-reading-from-stdin-fix.patch
fs-seq_filec-seq_read-update-pr_info_ratelimited.patch
