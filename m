From: akpm@linux-foundation.org
Subject: + checkpatch-only-flag-fsf-address-not-gnuorg-url.patch added to
 -mm tree
Date: Wed, 08 Jan 2014 14:20:45 -0800
Message-ID: <52cdcf3d.iYNfSxt1Ag1cLbc8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177AbaAHWUq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jan 2014 17:20:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, alexander.h.duyck@intel.com

Subject: + checkpatch-only-flag-fsf-address-not-gnuorg-url.patch added to -mm tree
To: alexander.h.duyck@intel.com,joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 08 Jan 2014 14:20:45 -0800


The patch titled
     Subject: checkpatch: only flag FSF address, not gnu.org URL
has been added to the -mm tree.  Its filename is
     checkpatch-only-flag-fsf-address-not-gnuorg-url.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-only-flag-fsf-address-not-gnuorg-url.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-only-flag-fsf-address-not-gnuorg-url.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: checkpatch: only flag FSF address, not gnu.org URL

This change restricts the check for the for the FSF address in the GPL
copyright statement so that it only flags the address, not the references
to the gnu.org/licenses URL which appears to be used in numerous drivers. 
The idea is to still allow some reference to an external copy of the GPL
in the event that files are copied out of the kernel tree without the
COPYING file.

So for example this statement will still return an error:
  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

However, this statement will not return an error after this patch:
  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-only-flag-fsf-address-not-gnuorg-url scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-only-flag-fsf-address-not-gnuorg-url
+++ a/scripts/checkpatch.pl
@@ -1970,14 +1970,12 @@ sub process {
 		}
 
 # Check for FSF mailing addresses.
-		if ($rawline =~ /\bYou should have received a copy/i ||
-		    $rawline =~ /\bwrite to the Free/i ||
+		if ($rawline =~ /\bwrite to the Free/i ||
 		    $rawline =~ /\b59\s+Temple\s+Pl/i ||
 		    $rawline =~ /\b51\s+Franklin\s+St/i) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
 			my $msg_type = \&ERROR;
 			$msg_type = \&CHK if ($file);
-			$msg_type = \&CHK if ($rawline =~ /\bYou should have received a copy/i);
 			&{$msg_type}("FSF_MAILING_ADDRESS",
 				     "Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.\n" . $herevet)
 		}
_

Patches currently in -mm which might be from alexander.h.duyck@intel.com are

checkpatch-only-flag-fsf-address-not-gnuorg-url.patch
linux-next.patch

