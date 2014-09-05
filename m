From: akpm@linux-foundation.org
Subject: + binfmt_misc-touch-up-documentation-a-bit.patch added to -mm
 tree
Date: Fri, 05 Sep 2014 16:06:30 -0700
Message-ID: <540a41f6.vrBZXaNVcv5x0Klu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbaIEXGb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Sep 2014 19:06:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_misc: touch up documentation a bit
has been added to the -mm tree.  Its filename is
     binfmt_misc-touch-up-documentation-a-bit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/binfmt_misc-touch-up-docum=
entation-a-bit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/binfmt_misc-touch-up-docum=
entation-a-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Mike Frysinger <vapier@gentoo.org>
Subject: binfmt_misc: touch up documentation a bit

Line wrap the content to 80 cols, and add more details to various field=
s
to match the code.  Drop reference to a website that does not exist
anymore.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/binfmt_misc.txt |   48 ++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff -puN Documentation/binfmt_misc.txt~binfmt_misc-touch-up-documentat=
ion-a-bit Documentation/binfmt_misc.txt
--- a/Documentation/binfmt_misc.txt~binfmt_misc-touch-up-documentation-=
a-bit
+++ a/Documentation/binfmt_misc.txt
@@ -15,39 +15,50 @@ First you must mount binfmt_misc:
 	mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc=20
=20
 To actually register a new binary type, you have to set up a string lo=
oking like
-:name:type:offset:magic:mask:interpreter:flags (where you can choose t=
he ':' upon
-your needs) and echo it to /proc/sys/fs/binfmt_misc/register.
+:name:type:offset:magic:mask:interpreter:flags (where you can choose t=
he ':'
+upon your needs) and echo it to /proc/sys/fs/binfmt_misc/register.
+
 Here is what the fields mean:
  - 'name' is an identifier string. A new /proc file will be created wi=
th this
-   name below /proc/sys/fs/binfmt_misc
+   name below /proc/sys/fs/binfmt_misc; cannot contain slashes '/' for=
 obvious
+   reasons.
  - 'type' is the type of recognition. Give 'M' for magic and 'E' for e=
xtension.
  - 'offset' is the offset of the magic/mask in the file, counted in by=
tes. This
-   defaults to 0 if you omit it (i.e. you write ':name:type::magic...'=
)
+   defaults to 0 if you omit it (i.e. you write ':name:type::magic...'=
). Ignored
+   when using filename extension matching.
  - 'magic' is the byte sequence binfmt_misc is matching for. The magic=
 string
-   may contain hex-encoded characters like \x0a or \xA4. In a shell en=
vironment
-   you will have to write \\x0a to prevent the shell from eating your =
\.
+   may contain hex-encoded characters like \x0a or \xA4. Note that you=
 must
+   escape any NUL bytes; parsing halts at the first one. In a shell en=
vironment
+   you might have to write \\x0a to prevent the shell from eating your=
 \.
    If you chose filename extension matching, this is the extension to =
be
    recognised (without the '.', the \x0a specials are not allowed). Ex=
tension
-   matching is case sensitive!
+   matching is case sensitive, and slashes '/' are not allowed!
  - 'mask' is an (optional, defaults to all 0xff) mask. You can mask ou=
t some
    bits from matching by supplying a string like magic and as long as =
magic.
-   The mask is anded with the byte sequence of the file.
+   The mask is anded with the byte sequence of the file. Note that you=
 must
+   escape any NUL bytes; parsing halts at the first one. Ignored when =
using
+   filename extension matching.
  - 'interpreter' is the program that should be invoked with the binary=
 as first
    argument (specify the full path)
  - 'flags' is an optional field that controls several aspects of the i=
nvocation
-   of the interpreter. It is a string of capital letters, each control=
s a certain
-   aspect. The following flags are supported -
-      'P' - preserve-argv[0].  Legacy behavior of binfmt_misc is to ov=
erwrite the
-            original argv[0] with the full path to the binary.  When t=
his flag is
-            included, binfmt_misc will add an argument to the argument=
 vector for
-            this purpose, thus preserving the original argv[0].
+   of the interpreter. It is a string of capital letters, each control=
s a
+   certain aspect. The following flags are supported -
+      'P' - preserve-argv[0]. Legacy behavior of binfmt_misc is to ove=
rwrite
+            the original argv[0] with the full path to the binary. Whe=
n this
+            flag is included, binfmt_misc will add an argument to the =
argument
+            vector for this purpose, thus preserving the original argv=
[0].
+            e.g. If your interp is set to /bin/foo and you run `blah` =
(which is
+            in /usr/local/bin), then the kernel will execute /bin/foo =
with
+            argv[] set to ["/bin/foo", "/usr/local/bin/blah", "blah"].=
  The
+            interp has to be aware of this so it can execute /usr/loca=
l/bin/blah
+            with argv[] set to ["blah"].
       'O' - open-binary. Legacy behavior of binfmt_misc is to pass the=
 full path
             of the binary to the interpreter as an argument. When this=
 flag is
             included, binfmt_misc will open the file for reading and p=
ass its
             descriptor as an argument, instead of the full path, thus =
allowing
-            the interpreter to execute non-readable binaries. This fea=
ture should
-            be used with care - the interpreter has to be trusted not =
to emit
-            the contents of the non-readable binary.
+            the interpreter to execute non-readable binaries. This fea=
ture
+            should be used with care - the interpreter has to be trust=
ed not to
+            emit the contents of the non-readable binary.
       'C' - credentials. Currently, the behavior of binfmt_misc is to =
calculate
             the credentials and security token of the new process acco=
rding to
             the interpreter. When this flag is included, these attribu=
tes are
@@ -110,7 +121,4 @@ passes it the full filename (or the file
 cause unexpected behaviour and can be a security hazard.
=20
=20
-There is a web page about binfmt_misc at
-http://www.tat.physik.uni-tuebingen.de
